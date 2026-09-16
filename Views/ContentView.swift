import SwiftUI

struct ContentView: View {
    @EnvironmentObject var hisenseService: HisenseService

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    if hisenseService.devices.isEmpty {
                        emptyState
                    } else {
                        devicesList
                    }
                }
                .padding()
            }
            .navigationTitle("Hisense AC Control")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { hisenseService.loadDevices() }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }

    var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "thermometer.sun.fill")
                .font(.system(size: 64))
                .foregroundColor(.blue)

            Text("No AC Devices Found")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Make sure your Hisense AC is connected to your WiFi network and try again.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: { hisenseService.loadDevices() }) {
                Text("Scan Again")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if hisenseService.isLoading {
                ProgressView()
            }

            Spacer()
        }
    }

    var devicesList: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(hisenseService.devices) { device in
                    NavigationLink(destination: ControlView(device: device)) {
                        DeviceCard(device: device)
                    }
                }
            }
        }
    }
}

struct DeviceCard: View {
    let device: ACDevice

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(device.name)
                        .font(.headline)
                        .foregroundColor(.primary)

                    HStack(spacing: 8) {
                        Image(systemName: device.isOnline ? "wifi" : "wifi.slash")
                            .font(.caption)
                            .foregroundColor(device.isOnline ? .green : .red)

                        Text(device.isOnline ? "Online" : "Offline")
                            .font(.caption)
                            .foregroundColor(device.isOnline ? .green : .red)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(device.temperature))°C")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("Target: \(Int(device.targetTemperature))°C")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            HStack(spacing: 12) {
                Label(device.isOn ? "On" : "Off", systemImage: device.isOn ? "power.circle.fill" : "power.circle")
                    .font(.caption)
                    .foregroundColor(device.isOn ? .green : .gray)

                Label(device.mode.rawValue.capitalized, systemImage: "fan.fill")
                    .font(.caption)
                    .foregroundColor(.blue)

                Label("\(device.humidity)%", systemImage: "humidity.fill")
                    .font(.caption)
                    .foregroundColor(.cyan)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    ContentView()
        .environmentObject(HisenseService())
}
