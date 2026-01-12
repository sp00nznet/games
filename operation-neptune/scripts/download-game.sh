#!/bin/bash
# Download Operation Neptune from Archive.org and prepare it for js-dos

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GAME_DIR="$SCRIPT_DIR/../game"
TEMP_DIR="$SCRIPT_DIR/../temp"

echo "=== Operation Neptune Download Script ==="
echo ""

# Create directories
mkdir -p "$GAME_DIR"
mkdir -p "$TEMP_DIR"

# Archive.org URLs for Operation Neptune
# Using the Super Solvers: Operation Neptune from The Learning Company
ARCHIVE_URL="https://archive.org/download/msdos_Super_Solvers_Operation_Neptune_1990/Super%20Solvers%20-%20Operation%20Neptune%20%281990%29%28The%20Learning%20Company%29.zip"
ALT_URL="https://archive.org/download/neptune_202204/neptune.zip"

echo "Downloading Operation Neptune..."

# Try primary URL first, fall back to alternate
if curl -L -f -o "$TEMP_DIR/neptune.zip" "$ARCHIVE_URL" 2>/dev/null; then
    echo "Downloaded from primary archive"
elif curl -L -f -o "$TEMP_DIR/neptune.zip" "$ALT_URL" 2>/dev/null; then
    echo "Downloaded from alternate archive"
else
    echo "ERROR: Failed to download from Archive.org"
    echo ""
    echo "Please manually download the game from one of these sources:"
    echo "  - https://archive.org/details/msdos_Super_Solvers_Operation_Neptune_1990"
    echo "  - https://archive.org/details/neptune_202204"
    echo ""
    echo "Then extract the ZIP and place the game files in: $TEMP_DIR/neptune/"
    exit 1
fi

echo "Extracting game files..."
cd "$TEMP_DIR"
unzip -o neptune.zip -d neptune_extract || true

# Find the game directory (structure varies by archive)
GAME_FILES=$(find neptune_extract -type f \( -iname "*.exe" -o -iname "*.com" \) | head -1)
GAME_FOLDER=$(dirname "$GAME_FILES")

if [ -z "$GAME_FILES" ]; then
    echo "ERROR: Could not find game executables"
    exit 1
fi

echo "Found game files in: $GAME_FOLDER"

# Create jsdos bundle
echo "Creating js-dos bundle..."

# Create the jsdos config
cat > "$TEMP_DIR/dosbox.conf" << 'EOF'
[sdl]
fullscreen=false
autolock=true

[dosbox]
machine=svga_s3

[cpu]
core=auto
cputype=auto
cycles=max

[mixer]
rate=44100
blocksize=1024

[midi]
mpu401=intelligent

[sblaster]
sbtype=sb16
sbbase=220
irq=7
dma=1
hdma=5
sbmixer=true
oplmode=auto

[autoexec]
@echo off
mount c .
c:
cls
EOF

# Find main executable
MAIN_EXE=$(find "$GAME_FOLDER" -maxdepth 1 -type f \( -iname "neptune.exe" -o -iname "neptune.com" -o -iname "*.exe" \) | head -1)
MAIN_EXE_NAME=$(basename "$MAIN_EXE")

# Add startup command to config
echo "$MAIN_EXE_NAME" >> "$TEMP_DIR/dosbox.conf"

# Create the .jsdos bundle (it's just a ZIP with specific structure)
mkdir -p "$TEMP_DIR/jsdos_bundle/.jsdos"
cp "$TEMP_DIR/dosbox.conf" "$TEMP_DIR/jsdos_bundle/.jsdos/dosbox.conf"
cp -r "$GAME_FOLDER"/* "$TEMP_DIR/jsdos_bundle/"

cd "$TEMP_DIR/jsdos_bundle"
zip -r "$GAME_DIR/neptune.jsdos" . -x "*.git*"

echo ""
echo "=== Success! ==="
echo "Game bundle created: $GAME_DIR/neptune.jsdos"
echo ""
echo "You can now start the web server to play the game."

# Cleanup
rm -rf "$TEMP_DIR"
