import Foundation
import Combine

class HisenseService: ObservableObject {
    @Published var devices: [ACDevice] = []
    @Published var isLoading = false
    @Published var error: String?

    private let networkService = NetworkService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadDevices()
    }

    func loadDevices() {
        isLoading = true
        networkService.discoverDevices()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] devices in
                self?.devices = devices
                self?.error = nil
            }
            .store(in: &cancellables)
    }

    func turnOn(_ device: ACDevice) {
        networkService.sendCommand(to: device, command: .turnOn)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = "Failed to turn on AC: \(error.localizedDescription)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    func turnOff(_ device: ACDevice) {
        networkService.sendCommand(to: device, command: .turnOff)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = "Failed to turn off AC: \(error.localizedDescription)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    func setTemperature(_ device: ACDevice, temperature: Double) {
        networkService.sendCommand(to: device, command: .setTemperature(Int(temperature)))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = "Failed to set temperature: \(error.localizedDescription)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    func setFanSpeed(_ device: ACDevice, speed: ACDevice.FanSpeed) {
        networkService.sendCommand(to: device, command: .setFanSpeed(speed.rawValue))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = "Failed to set fan speed: \(error.localizedDescription)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    func setMode(_ device: ACDevice, mode: ACDevice.ACMode) {
        networkService.sendCommand(to: device, command: .setMode(mode.rawValue))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = "Failed to set mode: \(error.localizedDescription)"
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }

    func refreshStatus(_ device: ACDevice) {
        networkService.getDeviceStatus(device)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = "Failed to refresh status: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] updatedDevice in
                self?.devices = self?.devices.map { $0.id == updatedDevice.id ? updatedDevice : $0 } ?? []
                self?.error = nil
            }
            .store(in: &cancellables)
    }
}
