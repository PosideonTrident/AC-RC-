import SwiftUI

struct ControlView: View {
    @EnvironmentObject var hisenseService: HisenseService
    let device: ACDevice

    @State private var tempValue: Double = 24.0
    @State private var selectedMode: ACDevice.ACMode = .cool
    @State private var selectedFanSpeed: ACDevice.FanSpeed = .auto

    var body: some View {
        ZStack {
            Color(.systemGray6)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    StatusSection(device: device)

                    PowerSection(device: device, hisenseService: hisenseService)

                    TemperatureSection(value: $tempValue, device: device, hisenseService: hisenseService)

                    ModeSection(selectedMode: $selectedMode, device: device, hisenseService: hisenseService)

                    FanSpeedSection(selectedFanSpeed: $selectedFanSpeed, device: device, hisenseService: hisenseService)

                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle(device.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tempValue = device.targetTemperature
            selectedMode = device.mode
            selectedFanSpeed = device.fanSpeed
        }
    }
}

struct StatusSection: View {
    let device: ACDevice

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Temperature")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(Int(device.temperature))°C")
                        .font(.title)
                        .fontWeight(.bold)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Humidity")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(device.humidity)%")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)

            HStack(spacing: 12) {
                StatusBadge(label: device.isOn ? "On" : "Off", color: device.isOn ? .green : .gray)
                StatusBadge(label: device.mode.rawValue.capitalized, color: .blue)
                StatusBadge(label: device.fanSpeed.rawValue.capitalized, color: .orange)
            }
        }
    }
}

struct StatusBadge: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(20)
    }
}

struct PowerSection: View {
    let device: ACDevice
    let hisenseService: HisenseService

    var body: some View {
        VStack(spacing: 12) {
            Text("Power")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                Button(action: { hisenseService.turnOn(device) }) {
                    Label("Turn On", systemImage: "power.circle.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(device.isOn ? Color.green : Color.gray.opacity(0.3))
                        .foregroundColor(device.isOn ? .white : .gray)
                        .cornerRadius(8)
                }

                Button(action: { hisenseService.turnOff(device) }) {
                    Label("Turn Off", systemImage: "power.circle")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!device.isOn ? Color.red : Color.gray.opacity(0.3))
                        .foregroundColor(!device.isOn ? .white : .gray)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct TemperatureSection: View {
    @Binding var value: Double
    let device: ACDevice
    let hisenseService: HisenseService

    var body: some View {
        VStack(spacing: 12) {
            Text("Target Temperature")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 16) {
                Button(action: { value = max(16, value - 1) }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }

                VStack(spacing: 4) {
                    Text("\(Int(value))°C")
                        .font(.title2)
                        .fontWeight(.bold)
                    Slider(value: $value, in: 16...32, step: 1)
                        .onChange(of: value) { newValue in
                            hisenseService.setTemperature(device, temperature: newValue)
                        }
                }

                Button(action: { value = min(32, value + 1) }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}

struct ModeSection: View {
    @Binding var selectedMode: ACDevice.ACMode
    let device: ACDevice
    let hisenseService: HisenseService

    let modes: [ACDevice.ACMode] = [.cool, .heat, .auto, .dry, .fan]

    var body: some View {
        VStack(spacing: 12) {
            Text("Mode")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 8) {
                ForEach(modes, id: \.self) { mode in
                    Button(action: {
                        selectedMode = mode
                        hisenseService.setMode(device, mode: mode)
                    }) {
                        HStack {
                            Image(systemName: modeIcon(mode))
                            Text(mode.rawValue.capitalized)
                            Spacer()
                            if selectedMode == mode {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(selectedMode == mode ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }

    func modeIcon(_ mode: ACDevice.ACMode) -> String {
        switch mode {
        case .cool: return "snowflake"
        case .heat: return "flame"
        case .auto: return "thermostat"
        case .dry: return "drop"
        case .fan: return "fan"
        }
    }
}

struct FanSpeedSection: View {
    @Binding var selectedFanSpeed: ACDevice.FanSpeed
    let device: ACDevice
    let hisenseService: HisenseService

    let speeds: [ACDevice.FanSpeed] = [.auto, .low, .medium, .high]

    var body: some View {
        VStack(spacing: 12) {
            Text("Fan Speed")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 8) {
                ForEach(speeds, id: \.self) { speed in
                    Button(action: {
                        selectedFanSpeed = speed
                        hisenseService.setFanSpeed(device, speed: speed)
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "fan.fill")
                                .font(.title3)
                            Text(speed.rawValue.capitalized)
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedFanSpeed == speed ? Color.orange : Color.gray.opacity(0.1))
                        .foregroundColor(selectedFanSpeed == speed ? .white : .primary)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        ControlView(device: ACDevice(
            id: "preview",
            name: "Living Room AC",
            ip: "192.168.1.100",
            port: 8080
        ))
        .environmentObject(HisenseService())
    }
}
