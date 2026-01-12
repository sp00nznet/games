#!/bin/bash
# Download Carmageddon Max Pack from Archive.org and prepare for js-dos
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GAME_DIR="$SCRIPT_DIR/../game"
TEMP_DIR="$SCRIPT_DIR/../temp"

echo "=== Carmageddon Max Pack Download Script ==="
echo ""

mkdir -p "$GAME_DIR" "$TEMP_DIR"

ARCHIVE_URL="https://archive.org/download/msdos_Carmageddon_Max_Pack_1998/Carmageddon%20Max%20Pack%20%281998%29%28SCi%20Games%29.zip"

echo "Downloading Carmageddon Max Pack..."
if ! curl -L -f -o "$TEMP_DIR/carmageddon.zip" "$ARCHIVE_URL" 2>/dev/null; then
    echo "ERROR: Failed to download from Archive.org"
    echo "Please manually download from: https://archive.org/details/msdos_Carmageddon_Max_Pack_1998"
    exit 1
fi

echo "Extracting game files..."
cd "$TEMP_DIR"
unzip -o carmageddon.zip -d carmageddon_extract || true

GAME_FILES=$(find carmageddon_extract -type f \( -iname "*.exe" -o -iname "*.com" \) | head -1)
GAME_FOLDER=$(dirname "$GAME_FILES")

if [ -z "$GAME_FILES" ]; then
    echo "ERROR: Could not find game executables"
    exit 1
fi

echo "Found game files in: $GAME_FOLDER"
echo "Creating js-dos bundle..."

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
[sblaster]
sbtype=sb16
sbbase=220
irq=7
dma=1
hdma=5
[autoexec]
@echo off
mount c .
c:
cls
EOF

MAIN_EXE=$(find "$GAME_FOLDER" -maxdepth 1 -type f \( -iname "carma*.exe" -o -iname "*.exe" \) | head -1)
MAIN_EXE_NAME=$(basename "$MAIN_EXE")
echo "$MAIN_EXE_NAME" >> "$TEMP_DIR/dosbox.conf"

mkdir -p "$TEMP_DIR/jsdos_bundle/.jsdos"
cp "$TEMP_DIR/dosbox.conf" "$TEMP_DIR/jsdos_bundle/.jsdos/dosbox.conf"
cp -r "$GAME_FOLDER"/* "$TEMP_DIR/jsdos_bundle/"

cd "$TEMP_DIR/jsdos_bundle"
zip -r "$GAME_DIR/carmageddon.jsdos" . -x "*.git*"

echo ""
echo "=== Success! ==="
echo "Game bundle created: $GAME_DIR/carmageddon.jsdos"
rm -rf "$TEMP_DIR"
