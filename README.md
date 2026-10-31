<p align="center">
  <img src="docs/banner.png" alt="Renovate Your TV — Sony Bravia KD-49X8200E" width="800">
</p>

# 🍎 Renovate Your TV — Sony Bravia KD-49X8200E Edition

> Transform your **Sony Bravia KD-49X8200E** (2017 Android TV, MediaTek MT5891, BRAVIA_ATV2 platform) into a super clean, responsive **Apple TV-style interface**.  
> Strip all ads, telemetry, Samba TV ACR trackers, and bloatware over Wi-Fi — with **zero root**, **nothing uninstalled**, and a **1-line restore**.

---

## ⚡ Quick Start (When You Are Home)

### 1. On Your TV Remote
1. Open **Settings** → **Device Preferences** → **About**.
2. Scroll to **Build** and press **OK 7 times** until it says *"You are now a developer"*.
3. Go back to **Settings** → **Device Preferences** → **Developer options**.
4. Turn **USB debugging** to **ON**.
5. Note your TV's IP address under **Settings** → **Network & Internet** (e.g. `192.168.29.50` on Jio Fiber).

### 2. On Your Laptop (Connected to Same Wi-Fi)
Run the automated renovator script:

```bash
./renovate_sony_bravia.sh 192.168.29.XXX
```

*When prompted on your TV screen, select **"Always allow from this computer"** with the remote.*

The script will automatically:
1. Probe the TV and verify ADB connectivity.
2. Back up all existing packages and system settings into `backup/`.
3. Apply the tested debloat list (`examples/sony-kd-49x8200e/debloat.txt`).
4. Build and install the ~572 KB native Apple TV launcher.
5. Set it as default Home and cleanly deactivate the stock ad-filled launcher.
6. Apply the Apple TV Cinematic theme.
7. Capture and save a verification screenshot to `shots/`.

---

## 🎨 What You Get

| Component | Description |
|---|---|
| **Pitch-Black Home** | Apple TV-style pitch black canvas with a rounded app dock. |
| **Top Shelf** | Names the focused app in large type with an ambient glow sampled from its artwork. |
| **Grid View** | Smoothly slides up on D-pad Down to browse other installed apps. |
| **Glass Highlight** | Fluid highlight spring animation between tiles. |
| **Frosted Top Pills** | Frosted status buttons for Inputs (HDMI 1-4, AV, Live TV), Wi-Fi (with network name), and Settings. |
| **Clock & Greeting** | Minimalist thin clock and date in the open Outfit font. |
| **Ultralight Launcher** | ~572 KB native Java APK. Zero internet permissions, zero analytics, zero background battery/CPU drain. |

---

## 🛡️ Safety & Reversibility

- **Never uninstalls:** Packages are only disabled in user space (`pm disable-user --user 0`).
- **One-line restore:** If you ever want the stock TV experience back:
  ```bash
  TV_HOST=192.168.29.XXX tools/restore.sh examples/sony-kd-49x8200e/debloat.txt
  ```
- **Protected hardware services:** `com.sony.dtv.tvx` (the core Sony HDMI and broadcast player), Bravia Sync (HDMI-CEC), remote Bluetooth pairing, and audio systems are permanently protected.
- **Home Guard:** Built-in safeguards prevent disabling the stock launcher unless the new launcher is verified running.

---

## 📁 Repository Structure

```
renovate_your_TV/
├── renovate_sony_bravia.sh         # 🚀 1-Click automated execution script
├── PROMPT.md                       # AI assistant prompt (pre-filled for KD-49X8200E)
├── examples/
│   └── sony-kd-49x8200e/           # Model-specific profile
│       ├── debloat.txt             # Tested debloat list for Sony BRAVIA_ATV2
│       ├── config.json             # Dock & key mapping config
│       ├── tv.json                 # TV platform metadata
│       └── README.md               # Quick instructions
├── launcher/                       # Source code for the 572 KB native launcher
├── themes/                         # Pre-built themes (cinematic, aurora, glass, default, etc.)
├── tools/                          # Pure-Python ADB client (tv.py), disable.sh, restore.sh
└── docs/
    ├── SONY_KD-49X8200E_GUIDE.md   # 📖 Comprehensive step-by-step documentation
    ├── TROUBLESHOOTING.md          # Fixes for common Android TV quirks
    ├── REMOTE.md                   # Connecting over Tailscale
    └── launcher.md                 # Launcher settings & configuration keys
```

---

## ⚙️ Customization

### Change Dock Apps
Edit `examples/sony-kd-49x8200e/config.json` or `launcher/app/src/main/res/values/config.xml`:

```json
{
  "dock_apps": [
    "com.netflix.ninja",
    "com.google.android.youtube.tv",
    "com.amazon.amazonvideo.livingroom",
    "in.startv.hotstar"
  ]
}
```

### Switch Themes (Without Rebuilding)
```bash
# Push the Cinematic theme (Apple TV 4K style)
TV_HOST=192.168.29.XXX tools/theme.sh themes/cinematic

# Push Aurora theme (wallpaper background)
TV_HOST=192.168.29.XXX tools/theme.sh themes/aurora

# Reset to default black
TV_HOST=192.168.29.XXX tools/theme.sh --reset
```

### Ad-Blocking DNS (Android 9+)
Block ads system-wide across all apps:
```bash
tools/venv/bin/python -I tools/tv.py 'settings put global private_dns_specifier dns.adguard-dns.com'
tools/venv/bin/python -I tools/tv.py 'settings put global private_dns_mode hostname'
```

---

## 🔒 Security: Close ADB When Finished

Once setup is complete, lock down ADB access for security:
1. On TV: **Developer options** → Turn **USB debugging** OFF and **Revoke authorizations**.
2. Reboot the TV.
3. Verify from laptop:
   ```bash
   python3 tools/adb-closed.py 192.168.29.XXX
   ```
The launcher will continue running without debugging enabled.

---

## 📖 In-Depth Guide
For comprehensive step-by-step explanations, troubleshooting, and preparation details, see [docs/SONY_KD-49X8200E_GUIDE.md](docs/SONY_KD-49X8200E_GUIDE.md).
