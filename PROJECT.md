# Hisense AC iPhone App

A native iOS application for controlling Hisense air conditioning units remotely from your iPhone.

## Overview

This app allows you to:
- Discover and connect to Hisense AC units on your local WiFi network
- Control power (on/off)
- Adjust target temperature (16°C - 32°C)
- Select operating modes (Cool, Heat, Auto, Dry, Fan)
- Control fan speed (Auto, Low, Medium, High)
- Monitor real-time temperature and humidity
- View AC status and connectivity

## Architecture

### Project Structure

```
HisenseAC/
├── App/
│   └── HisenseACApp.swift          # App entry point
├── Views/
│   ├── ContentView.swift            # Main device list
│   └── ControlView.swift            # AC control interface
├── Models/
│   └── ACDevice.swift               # Data model for AC units
├── Services/
│   ├── HisenseService.swift         # Business logic & state management
│   └── NetworkService.swift         # Network communication
└── PROJECT.md
```

### Design Patterns

- **MVVM with ObservableObject**: HisenseService manages state
- **Combine Framework**: Reactive updates with Publishers/Subscribers
- **SwiftUI**: Modern declarative UI
- **REST API**: HTTP communication with AC units

## Key Components

### ACDevice Model
Represents a Hisense AC unit with properties:
- id, name, ip, port (device identification)
- temperature, targetTemperature, humidity (current state)
- isOn, fanSpeed, mode (control state)
- isOnline (connectivity status)

### HisenseService
ObservableObject that manages:
- Device discovery and scanning
- Command execution (turn on/off, set temperature, mode, fan speed)
- Status refresh
- Error handling

### NetworkService
Handles low-level communication:
- Device discovery over local network
- Command sending via HTTP POST
- Status polling via HTTP GET
- Payload serialization/deserialization

## Communication Protocol

### Commands (POST to `/command`)
```json
{
  "command": "power|temperature|fanSpeed|mode",
  "value": <appropriate_value>
}
```

### Status (GET from `/status`)
```json
{
  "power": bool,
  "temperature": double,
  "targetTemperature": double,
  "fanSpeed": "auto|low|medium|high",
  "mode": "cool|heat|auto|dry|fan",
  "humidity": int
}
```

## Getting Started

### Prerequisites
- Xcode 13+
- iOS 15+
- Swift 5.5+
- Hisense AC unit connected to same WiFi network

### Setup

1. **Open in Xcode**
   - File → Open → Select HisenseAC folder
   - Or create new iOS App project and add these files

2. **Configure Network Settings**
   - Edit Hisense AC IP address if needed (in `NetworkService.discoverDevices()`)
   - Add Local Network privacy in Info.plist:
     ```xml
     <key>NSLocalNetworkUsageDescription</key>
     <string>This app needs access to discover Hisense AC units on your network</string>
     <key>NSBonjourServices</key>
     <array>
       <string>_hisense._tcp</string>
     </array>
     ```

3. **Build & Run**
   ```
   Cmd + R in Xcode
   ```

## Development

### Adding New Features

1. **New Control Type**: Add case to `NetworkService.Command` enum
2. **New Device Property**: Add to `ACDevice` struct
3. **New UI Control**: Create new section View in ControlView.swift

### Testing

- Mock device data is provided in `NetworkService.discoverDevices()`
- Modify mock data to test different scenarios
- Connect to real AC unit after testing

## Networking

The app communicates with AC units via:
- **Protocol**: HTTP REST API
- **Port**: Typically 8080 (configurable)
- **Timeout**: 10 seconds
- **Local Network**: Requires iOS 14.5+ local network access

## Error Handling

Common errors and recovery:
- **Connection Failed**: AC unit offline or unreachable
- **Invalid Response**: Protocol mismatch or AC error
- **Decoding Error**: Response format unexpected
- **Invalid Command**: AC unit rejected command

Check the `error` property on HisenseService for error messages.

## Future Enhancements

- [ ] Device pairing/configuration
- [ ] Scheduling and automation
- [ ] Energy consumption tracking
- [ ] Multi-room support
- [ ] Homekit integration
- [ ] Push notifications for events
- [ ] Cloud sync capabilities

## Hardware Requirements

- iPhone running iOS 15+
- Hisense AC unit with WiFi module
- Local WiFi network connectivity

## License

MIT
