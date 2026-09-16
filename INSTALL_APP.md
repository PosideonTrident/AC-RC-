# Install as iPhone App (No Xcode Needed!)

## What This Is

This is a **PWA (Progressive Web App)** - it works like a native app on your iPhone home screen, but it's actually a web app. No app store, no code signing, no developer account needed.

---

## Installation (30 Seconds)

### Step 1: Start the Server on Your Computer
```bash
cd AC-RC-
pip install -r requirements.txt
python app.py
```

### Step 2: Find Your Computer's IP
**Mac:**
- System Preferences → Network → Look for 192.168.x.x

**Windows:**
- Settings → Network → Look for 192.168.x.x

Example: `192.168.1.50`

### Step 3: Open Safari on iPhone
1. Open **Safari** (not Chrome, must be Safari for iPhone)
2. Go to: `http://192.168.1.50:5000` (use YOUR IP)
3. Wait for page to load

### Step 4: Add to Home Screen (THE APP)
1. Tap the **Share** button (square with arrow) at bottom
2. Scroll down and tap **"Add to Home Screen"**
3. Name it whatever you want (default: "Hisense AC")
4. Tap **"Add"**

### Step 5: Done! 🎉
- **Icon appears on home screen** - looks like an app
- **Tap to open** - launches full screen like a native app
- **Scans for AC automatically** - just tap "Scan"
- **Stays in background** - runs when you're not using it

---

## It's Just Like an App

✅ Home screen icon  
✅ Full screen (no Safari UI)  
✅ Instant launch  
✅ Works offline (basic features)  
✅ Can stay open in background  
✅ Push notifications (future)  
✅ Local storage for preferences (future)  

---

## How It Works

### First Time
1. Tap app icon
2. Tap "Scan for AC"
3. Finds your Hisense AC on WiFi
4. Tap to select
5. Control everything!

### After That
- App remembers your AC
- Launches straight to control screen
- Updates every 3 seconds

---

## Troubleshooting

### "Add to Home Screen" doesn't appear?
- Make sure using **Safari**, not Chrome
- Make sure it says "PWA" somewhere (it's a web app)
- Try reloading the page: Pull down to refresh

### Icon doesn't work?
- Make sure server is still running
- Check you're on same WiFi
- Try reinstalling: Delete from home screen, re-add

### Shows "Can't connect" when offline?
- That's normal - it needs WiFi to the server
- App will reconnect when back online

---

## Best Setup

**For Bedroom Use:**
1. Computer in living room (running server)
2. iPhone on WiFi
3. App on home screen
4. Tap anytime to control AC from bed

---

## Why This Is Better Than Web Browser

**Before:** Open Safari → Type URL → Scan → Control  
**Now:** Tap app icon → Control

Takes 1 second instead of 10 seconds!

---

## Advanced: Keeping Server Running

You want the server to keep running when your computer is asleep.

### Mac - Keep Running in Background
```bash
# In Terminal, this keeps it running:
nohup python app.py > ac-control.log 2>&1 &

# Now you can close the Terminal window
# and the app keeps running

# To stop it later:
killall python
```

### Windows - Task Scheduler
1. Open Task Scheduler
2. Create new task
3. Set to run `python app.py` at startup
4. It runs in background automatically

### Or Just Leave Computer On
Simplest: Keep computer on 24/7 (uses ~20W of power)

---

## Privacy & Security

✅ **All local** - Never leaves your home WiFi  
✅ **No cloud** - No data sent anywhere  
✅ **No account** - No username/password  
✅ **Open source** - Check the code anytime  

---

## Future Features

- 📍 Control from outside home (cloud sync)
- 🔔 Push notifications for AC events
- ⏰ Scheduling (set to cool at 10pm)
- 📊 Energy usage tracking
- 🏠 HomeKit integration

---

## Questions?

**Q: Can I control from outside my home?**  
A: Not yet. Currently local WiFi only.

**Q: Does it work if phone sleeps?**  
A: App closes when you switch to other app (normal), but reopens instantly when tapped.

**Q: Can I use on Android?**  
A: Yes! Open in Chrome, same process.

**Q: Can I share with family?**  
A: Yes! Anyone on WiFi can access. They visit the same URL.

---

## Enjoy!

Now you have a real iOS app that controls your AC. Control from bed, no Xcode needed. 🎉

Questions? Check QUICK_START.md for more details.
