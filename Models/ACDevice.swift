import Foundation

struct ACDevice: Identifiable, Codable {
    let id: String
    let name: String
    let ip: String
    let port: Int

    var isOnline: Bool = false
    var temperature: Double = 24.0
    var targetTemperature: Double = 24.0
    var isOn: Bool = false
    var fanSpeed: FanSpeed = .auto
    var mode: ACMode = .cool
    var humidity: Int = 50

    enum FanSpeed: String, Codable {
        case auto = "auto"
        case low = "low"
        case medium = "medium"
        case high = "high"
    }

    enum ACMode: String, Codable {
        case cool = "cool"
        case heat = "heat"
        case auto = "auto"
        case dry = "dry"
        case fan = "fan"
    }
}
