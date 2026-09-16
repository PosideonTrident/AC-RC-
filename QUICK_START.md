# Quick Start - Web App (Easiest Way)

## What You Get
✅ Web app runs on your computer  
✅ Auto-discovers your Hisense AC on WiFi  
✅ Control from iPhone Safari browser  
✅ No app store needed  
✅ Works from bed

---

## 5-Minute Setup

### Step 1: Install Python (if needed)
```bash
# Mac
brew install python3

# Windows
# Download from python.org
```

### Step 2: Download & Setup
```bash
# Go to the AC-RC- folder
cd AC-RC-

# Install dependencies
pip install -r requirements.txt
```

### Step 3: Start the Server
```bash
python app.py
```

You should see:
```
==================================================
Hisense AC Control - Web App
==================================================

[*] Starting server...
[*] Open http://localhost:5000 in your browser
[*] Or from your iPhone: http://<your-computer-ip>:5000
```

### Step 4: Open on iPhone
1. Open **Safari** on your iPhone
2. Go to: `http://<YOUR_COMPUTER_IP>:5000`
   - Find your computer IP: 
     - Mac: System Preferences → Network (look for "192.168.x.x")
     - Windows: Settings → Network (look for "192.168.x.x")
   - Example: `http://192.168.1.50:5000`
3. Tap **"Scan for AC"**
4. Wait for it to find your AC unit
5. **Tap your AC** to select it
6. **You're done!** Control from bed 🎉

---

## What The App Does

### Auto-Discovery 🔍
- Scans your entire WiFi network
- Finds your Hisense AC automatically
- No manual IP entry needed

### Full Control
- **Power**: Turn AC on/off
- **Temperature**: Slide 16-32°C
- **Mode**: Cool, Heat, Dry, Fan
- **Fan Speed**: Auto, Low, Medium, High

### Real-Time Status
- Shows current temperature
- Displays humidity
- Shows current mode & fan speed
- Auto-updates every 3 seconds

---

## Troubleshooting

### "No Hisense AC found!"
This means your AC doesn't have WiFi. Options:
1. Check if AC has WiFi module installed
2. Buy Broadlink RM4 IR blaster (~$50)
3. Check if AC needs manual WiFi setup

### Can't access from iPhone?
- Make sure iPhone is on **same WiFi** as computer
- Use actual IP, not localhost
- Check computer's firewall settings

### Server won't start?
```bash
# Try Python 3 explicitly
python3 app.py

# Or check port is free
# If port 5000 is taken, edit app.py last line:
# app.run(host='0.0.0.0', port=5000, debug=False)
# Change 5000 to 5001 or another number
```

---

## Advanced: Using Broadlink IR Blaster

If your AC doesn't have WiFi, you can use a Broadlink RM4 IR blaster:

1. **Buy**: Broadlink RM4 (~$50)
2. **Setup**: Connect to WiFi using Broadlink app
3. **Learn**: Teach it your AC remote codes
4. We can integrate Broadlink API into this web app

[Coming soon: Broadlink integration guide]

---

## Keep Server Running

### Option 1: Terminal (Simple)
Just leave Terminal window open while using

### Option 2: Run in Background (Mac)
```bash
nohup python app.py > ac-control.log &
```

### Option 3: Run in Background (Windows)
Use Task Scheduler to run app at startup

### Option 4: Use Screen/Tmux (Linux/Mac)
```bash
screen -S ac-control
python app.py
# Press Ctrl+A then D to detach
```

---

## For Your Bedroom

**Ideal Setup:**
1. Computer in living room (or wherever AC is)
2. Server runs 24/7 in background
3. Open Safari on iPhone from bed
4. Control AC without getting up

---

## Questions?

1. **"Can I control from outside my home?"**
   - Not currently (local network only)
   - Would need cloud setup (more complex)

2. **"Will it work offline?"**
   - No, AC must be on WiFi

3. **"Can multiple phones control?"**
   - Yes! Anyone on same WiFi can access

---

## Next Steps

1. Make sure AC is connected to WiFi (check for WiFi light)
2. Run the server
3. Scan and connect
4. Control from bed!

Enjoy! 🎉
