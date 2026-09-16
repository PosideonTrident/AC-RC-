import Foundation
import Combine

class NetworkService {
    enum NetworkError: Error {
        case invalidResponse
        case decodingError
        case connectionFailed
        case invalidCommand
    }

    enum Command {
        case turnOn
        case turnOff
        case setTemperature(Int)
        case setFanSpeed(String)
        case setMode(String)
    }

    private let session = URLSession.shared
    private let baseTimeout: TimeInterval = 10

    func discoverDevices() -> AnyPublisher<[ACDevice], Error> {
        Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let mockDevices = [
                    ACDevice(
                        id: "hisense_ac_001",
                        name: "Living Room AC",
                        ip: "192.168.1.100",
                        port: 8080,
                        isOnline: true,
                        temperature: 22.5,
                        targetTemperature: 24.0,
                        isOn: true,
                        fanSpeed: .auto,
                        mode: .cool,
                        humidity: 45
                    )
                ]
                promise(.success(mockDevices))
            }
        }
        .eraseToAnyPublisher()
    }

    func sendCommand(to device: ACDevice, command: Command) -> AnyPublisher<Void, Error> {
        Future { promise in
            let payload = buildCommandPayload(command)
            let url = URL(string: "http://\(device.ip):\(device.port)/command")!

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = self.baseTimeout

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: payload)
            } catch {
                promise(.failure(NetworkError.invalidCommand))
                return
            }

            self.session.dataTask(with: request) { _, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    promise(.failure(NetworkError.invalidResponse))
                    return
                }

                promise(.success(()))
            }.resume()
        }
        .eraseToAnyPublisher()
    }

    func getDeviceStatus(_ device: ACDevice) -> AnyPublisher<ACDevice, Error> {
        Future { promise in
            let url = URL(string: "http://\(device.ip):\(device.port)/status")!
            var request = URLRequest(url: url)
            request.timeoutInterval = self.baseTimeout

            self.session.dataTask(with: request) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let data = data else {
                    promise(.failure(NetworkError.invalidResponse))
                    return
                }

                do {
                    let statusData = try JSONDecoder().decode(StatusPayload.self, from: data)
                    var updatedDevice = device
                    updatedDevice.isOn = statusData.power
                    updatedDevice.temperature = statusData.temperature
                    updatedDevice.targetTemperature = statusData.targetTemperature
                    updatedDevice.fanSpeed = ACDevice.FanSpeed(rawValue: statusData.fanSpeed) ?? .auto
                    updatedDevice.mode = ACDevice.ACMode(rawValue: statusData.mode) ?? .cool
                    updatedDevice.humidity = statusData.humidity
                    updatedDevice.isOnline = true

                    promise(.success(updatedDevice))
                } catch {
                    promise(.failure(NetworkError.decodingError))
                }
            }.resume()
        }
        .eraseToAnyPublisher()
    }

    private func buildCommandPayload(_ command: Command) -> [String: Any] {
        switch command {
        case .turnOn:
            return ["command": "power", "value": true]
        case .turnOff:
            return ["command": "power", "value": false]
        case .setTemperature(let temp):
            return ["command": "temperature", "value": temp]
        case .setFanSpeed(let speed):
            return ["command": "fanSpeed", "value": speed]
        case .setMode(let mode):
            return ["command": "mode", "value": mode]
        }
    }
}

struct StatusPayload: Decodable {
    let power: Bool
    let temperature: Double
    let targetTemperature: Double
    let fanSpeed: String
    let mode: String
    let humidity: Int
}
