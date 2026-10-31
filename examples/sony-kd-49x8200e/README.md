# Sony Bravia KD-49X8200E Configuration

This folder contains the tested configuration and debloat list for the **Sony Bravia KD-49X8200E** (2017, Android TV, MediaTek MT5891 chipset, BRAVIA_ATV2 platform).

## Device Specific Details
- **Platform:** Sony BRAVIA_ATV2 (MediaTek MT5891)
- **RAM:** 2 GB
- **OS Version:** Android TV 8.0 or 9
- **Stock Launcher:** `com.google.android.tvlauncher` (or leanback launcher)
- **Live TV & HDMI Input App:** `com.sony.dtv.tvx` (MUST be kept enabled!)
- **Remote App Buttons:** YouTube (scan:485), Prime Video (scan:490)

## Quick Run

```bash
# 1. Connect (ensure laptop & TV are on same Wi-Fi, e.g. Jio Fiber)
export TV_HOST=192.168.29.XXX  # Replace with your TV IP
tools/venv/bin/python -I tools/tv.py --probe

# 2. Debloat
tools/disable.sh examples/sony-kd-49x8200e/debloat.txt

# 3. Build & Install Clean Apple TV Launcher
TV_HOST=$TV_HOST launcher/build-and-install.sh

# 4. Push theme (e.g. cinematic or aurora)
TV_HOST=$TV_HOST tools/theme.sh themes/cinematic

# 5. Restore if ever needed
tools/restore.sh examples/sony-kd-49x8200e/debloat.txt
```

