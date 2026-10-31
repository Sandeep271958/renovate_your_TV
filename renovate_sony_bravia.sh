#!/usr/bin/env bash
# ==============================================================================
# Renovate Sony Bravia KD-49X8200E -> Clean Apple TV UI
# ==============================================================================
# Cloned from cleanYourTV and customized for Sony Bravia KD-49X8200E
# Repo: https://github.com/Sandeep271958/renovate_your_TV
# ==============================================================================

set -euo pipefail

TV_IP="${1:-${TV_HOST:-}}"

if [ -z "$TV_IP" ]; then
    echo "====================================================================="
    echo "  📺 Sony Bravia KD-49X8200E Renovator (Apple TV UI)"
    echo "====================================================================="
    echo "Enter your TV's local IP address (e.g. 192.168.29.50 on Jio Fiber):"
    read -r -p "TV IP: " TV_IP
fi

if [ -z "$TV_IP" ]; then
    echo "Error: No TV IP provided. Exiting."
    exit 1
fi

export TV_HOST="$TV_IP"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

echo "---------------------------------------------------------------------"
echo "Target TV: $TV_HOST"
echo "---------------------------------------------------------------------"

# 1. Check Python Venv
if [ ! -d "tools/venv" ]; then
    echo "Setting up Python virtual environment..."
    python3 -m venv tools/venv
    tools/venv/bin/pip install --quiet -r tools/requirements.txt
fi

PY="tools/venv/bin/python"

# 2. Test Connection
echo ""
echo ">> Step 1/6: Probing TV at $TV_HOST..."
echo "NOTE: If this is the first time connecting, look at the TV screen"
echo "      and press 'Always allow from this computer' on the remote!"
echo ""

$PY -I tools/tv.py --probe || {
    echo "Failed to connect to TV at $TV_HOST."
    echo "Check that USB Debugging is ON in Developer Options on the TV,"
    echo "and that your laptop and TV are connected to the same Wi-Fi."
    exit 1
}

# 3. Create Backup
echo ""
echo ">> Step 2/6: Creating system backup in backup/..."
mkdir -p backup shots
$PY -I tools/tv.py 'pm list packages' > backup/packages-all.txt || true
$PY -I tools/tv.py 'pm list packages -d' > backup/packages-disabled.txt || true
$PY -I tools/tv.py 'getprop' > backup/getprop.txt || true
$PY -I tools/tv.py 'settings list global' > backup/settings-global.txt || true
$PY -I tools/tv.py 'settings list secure' > backup/settings-secure.txt || true
$PY -I tools/tv.py 'settings list system' > backup/settings-system.txt || true
$PY -I tools/tv.py --screenshot shots/00-before.png || true
echo "Backup complete! Initial screenshot saved to shots/00-before.png"

# 4. Debloat
echo ""
echo ">> Step 3/6: Applying debloat list for Sony KD-49X8200E..."
./tools/disable.sh examples/sony-kd-49x8200e/debloat.txt

# 5. Build and Install Launcher
echo ""
echo ">> Step 4/6: Building & Installing clean Apple TV Launcher..."
./launcher/build-and-install.sh

# 6. Re-run debloat to clean stock launcher now that replacement is active
echo ""
echo ">> Step 5/6: Finalizing Home switch..."
./tools/disable.sh examples/sony-kd-49x8200e/debloat.txt || true

# 7. Apply Cinematic Theme
echo ""
echo ">> Step 6/6: Applying Apple TV Cinematic Theme..."
./tools/theme.sh themes/cinematic || true

# 8. Verification Screenshot
echo ""
echo "Taking verification screenshot..."
$PY -I tools/tv.py --screenshot shots/01-after-apple-tv.png || true

echo ""
echo "====================================================================="
echo "  🎉 Transformation Complete!"
echo "====================================================================="
echo "Your Sony Bravia KD-49X8200E now has a clean Apple TV UI!"
echo "Screenshot saved to: shots/01-after-apple-tv.png"
echo ""
echo "To restore everything back to factory defaults at any time, run:"
echo "  tools/restore.sh examples/sony-kd-49x8200e/debloat.txt"
echo "====================================================================="

