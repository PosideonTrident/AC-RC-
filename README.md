# Hisense AC Remote Control - iPhone App

A native iOS application to remotely control Hisense air conditioning units from your iPhone.

## Features

✅ **Device Discovery** - Automatically find Hisense AC units on your WiFi network
✅ **Power Control** - Turn AC on/off with a single tap
✅ **Temperature Control** - Adjust target temperature from 16°C to 32°C
✅ **Mode Selection** - Choose between Cool, Heat, Auto, Dry, and Fan modes
✅ **Fan Speed Control** - Select Auto, Low, Medium, or High fan speeds
✅ **Real-time Monitoring** - View current temperature, humidity, and connectivity status
✅ **Modern UI** - Built with SwiftUI for a smooth, responsive experience

## Quick Start

### Requirements
- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+
- Hisense AC unit with WiFi connectivity

### Setup

1. **See [SETUP.md](SETUP.md)** for detailed installation instructions
2. Update your AC unit's IP address in the code
3. Build and run on your iPhone

## Project Structure

```
├── App/
│   └── HisenseACApp.swift          # App entry point
├── Views/
│   ├── ContentView.swift            # Device list view
│   └── ControlView.swift            # AC control interface
├── Models/
│   └── ACDevice.swift               # AC device data model
├── Services/
│   ├── HisenseService.swift         # State management (ViewModel)
│   └── NetworkService.swift         # Network communication layer
├── PROJECT.md                       # Technical documentation
├── SETUP.md                         # Setup & configuration guide
└── README.md
```

## Architecture

Built using modern iOS best practices:

- **MVVM Pattern** - Model-View-ViewModel with clean separation of concerns
- **Combine Framework** - Reactive programming with Publishers/Subscribers
- **SwiftUI** - Declarative UI framework for iOS 15+
- **REST API** - HTTP communication over local WiFi network

## Documentation

- **[SETUP.md](SETUP.md)** - Complete setup and installation guide
- **[PROJECT.md](PROJECT.md)** - Technical architecture and API documentation

## How It Works

1. **Discovery**: App scans local WiFi network for Hisense AC devices
2. **Connection**: Communicates via HTTP REST API on port 8080
3. **Control**: Sends commands to AC unit (power, temperature, mode, fan speed)
4. **Monitoring**: Polls device for real-time status and display updates

## Getting Your AC Unit Ready

1. Connect your Hisense AC to WiFi via its built-in interface
2. Note the IP address (check router or Hisense app)
3. Ensure AC unit is on the same WiFi network as your iPhone
4. Update the IP in the app configuration

## Troubleshooting

**AC unit not found?**
- Verify AC and iPhone are on same WiFi network
- Check AC IP address is correct
- Ensure AC unit is powered on

**Commands not working?**
- Check WiFi connectivity
- Verify AC unit API is accessible
- Try restarting AC unit

See [SETUP.md](SETUP.md) for detailed troubleshooting.

## Development Status

🚀 **Initial Release** - Core functionality complete:
- [x] Device discovery
- [x] Power on/off
- [x] Temperature control
- [x] Mode selection
- [x] Fan speed control
- [x] Status monitoring

**Future Features** (Planned):
- [ ] Device management & favorites
- [ ] Scheduling & automation
- [ ] Energy consumption tracking
- [ ] HomeKit integration
- [ ] Cloud sync support
- [ ] Multi-device control

## License

MIT

## Support

For issues or questions, check the documentation in SETUP.md and PROJECT.md, or review the network communication code in Services/NetworkService.swift.

---

**Stay cool! 🧊** Control your AC from anywhere in your home.
