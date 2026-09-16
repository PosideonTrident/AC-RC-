# Setup Guide - Hisense AC iPhone App

## Quick Start (5 minutes)

### Step 1: Create Xcode Project

1. Open Xcode
2. File → New → Project
3. Select "App" (iOS)
4. Fill in:
   - Product Name: `HisenseAC`
   - Team: Your team
   - Organization: Your organization
   - Bundle Identifier: `com.yourname.hisense-ac`
   - Interface: SwiftUI
   - Language: Swift

### Step 2: Add Source Files

1. Copy all files from this directory into your Xcode project:
   - HisenseACApp.swift → App folder
   - ACDevice.swift → Models folder
   - HisenseService.swift, NetworkService.swift → Services folder
   - ContentView.swift, ControlView.swift → Views folder

2. In Xcode: File → Add Files to "HisenseAC"
3. Select all Swift files
4. ✓ Copy items if needed
5. ✓ Create groups

### Step 3: Configure Info.plist

1. Right-click `Info.plist` → Open As → Source Code
2. Add these keys before closing `</dict>`:

```xml
<key>NSLocalNetworkUsageDescription</key>
<string>This app needs access to your local network to discover and control Hisense AC units</string>
<key>NSBonjourServices</key>
<array>
    <string>_hisense._tcp</string>
    <string>_http._tcp</string>
</array>
```

### Step 4: Update AC Device IP

Edit `Services/NetworkService.swift` → `discoverDevices()` function:

```swift
// Change this IP to your Hisense AC's IP
let mockDevices = [
    ACDevice(
        id: "hisense_ac_001",
        name: "Living Room AC",
        ip: "192.168.1.100",  // ← Change this
        port: 8080,
        ...
    )
]
```

### Step 5: Build & Run

1. Select your iPhone from Xcode's device menu
2. Press `Cmd + R`
3. The app should launch and discover your AC unit

## Finding Your AC Unit's IP Address

### Option 1: Router Admin Panel
1. Login to your WiFi router
2. Look for "Connected Devices" or "DHCP Clients"
3. Find device starting with "Hisense"
4. Note its IP address

### Option 2: Hisense App
1. Open official Hisense app
2. Check device settings for IP
3. Or use same WiFi and make note of IP

### Option 3: Network Scanner
1. Use app like "Network Analyzer" or "Fing"
2. Scan your WiFi network
3. Look for Hisense device
4. Note the IP address

## Testing with Mock Data

The app comes with mock data for testing:
1. Build & run without changes
2. You'll see "Living Room AC" with test values
3. Tap to open control panel
4. Test UI interactions (all commands are simulated)

## Connect to Real AC Unit

When ready to connect to real hardware:

1. **Get AC IP Address** (see above)
2. **Update IP in code**:
   - Edit `NetworkService.swift`
   - Find `discoverDevices()` method
   - Change IP address
3. **Rebuild & run**
4. App should connect and show real values

## Troubleshooting

### App Can't Find AC Unit
- ✓ AC and iPhone on same WiFi network
- ✓ AC unit powered on
- ✓ Correct IP address in code
- ✓ AC is not in sleep/standby mode

### Commands Not Working
- ✓ Check network connectivity
- ✓ Ensure AC unit supports HTTP API
- ✓ Verify port 8080 is open
- ✓ Check AC unit's error logs

### Connection Timeout
- ✓ Increase timeout in `NetworkService` (currently 10s)
- ✓ Check WiFi signal strength
- ✓ Reduce network congestion

### Temperature Won't Update
- ✓ AC may not support temp sensor API
- ✓ Check AC unit documentation
- ✓ Verify JSON response format

## Requirements Check

Before deploying to device:

- [ ] Xcode 13.0+ installed
- [ ] iOS 15.0+ target device
- [ ] Swift 5.5+ available
- [ ] AC unit IP address confirmed
- [ ] WiFi network working
- [ ] Local network permissions granted

## Next Steps

After basic setup works:

1. **Add Device Management**
   - Store discovered devices
   - Save favorite devices

2. **Enhance UI**
   - Add custom themes
   - Improve layouts
   - Add animations

3. **Add Features**
   - Scheduling support
   - Energy tracking
   - HomeKit integration

## Support

For AC protocol issues:
1. Check Hisense AC documentation
2. Verify HTTP API endpoints
3. Test with curl on same network

Example:
```bash
curl -X POST http://192.168.1.100:8080/command \
  -H "Content-Type: application/json" \
  -d '{"command":"power","value":true}'
```
