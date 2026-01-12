#!/bin/bash
# Download Epic Pinball from Archive.org and prepare for js-dos
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GAME_DIR="$SCRIPT_DIR/../game"
TEMP_DIR="$SCRIPT_DIR/../temp"

echo "=== Epic Pinball Download Script ==="
echo ""

mkdir -p "$GAME_DIR" "$TEMP_DIR"

ARCHIVE_URL="https://archive.org/download/epicpin_202406/epicpin.zip"
ALT_URL="https://archive.org/download/EpicPinballSW1993EpicMegaGamesInc.Action/Epic%20Pinball%20%28SW%29%20%281993%29%28Epic%20MegaGames%2C%20Inc.%29%28Action%29.zip"

echo "Downloading Epic Pinball..."
if curl -L -f -o "$TEMP_DIR/epicpin.zip" "$ARCHIVE_URL" 2>/dev/null; then
    echo "Downloaded from primary archive"
elif curl -L -f -o "$TEMP_DIR/epicpin.zip" "$ALT_URL" 2>/dev/null; then
    echo "Downloaded from alternate archive"
else
    echo "ERROR: Failed to download from Archive.org"
    echo "Please manually download from: https://archive.org/details/epicpin_202406"
    exit 1
fi

echo "Extracting game files..."
cd "$TEMP_DIR"
unzip -o epicpin.zip -d epicpin_extract || true

GAME_FILES=$(find epicpin_extract -type f \( -iname "*.exe" -o -iname "*.com" \) | head -1)
GAME_FOLDER=$(dirname "$GAME_FILES")

if [ -z "$GAME_FILES" ]; then
    GAME_FOLDER="$TEMP_DIR/epicpin_extract"
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

MAIN_EXE=$(find "$GAME_FOLDER" -maxdepth 2 -type f \( -iname "pinball*.exe" -o -iname "epic*.exe" -o -iname "*.exe" \) | head -1)
MAIN_EXE_NAME=$(basename "$MAIN_EXE")
echo "$MAIN_EXE_NAME" >> "$TEMP_DIR/dosbox.conf"

mkdir -p "$TEMP_DIR/jsdos_bundle/.jsdos"
cp "$TEMP_DIR/dosbox.conf" "$TEMP_DIR/jsdos_bundle/.jsdos/dosbox.conf"
cp -r "$GAME_FOLDER"/* "$TEMP_DIR/jsdos_bundle/" 2>/dev/null || cp -r "$TEMP_DIR/epicpin_extract"/* "$TEMP_DIR/jsdos_bundle/"

cd "$TEMP_DIR/jsdos_bundle"
zip -r "$GAME_DIR/epicpin.jsdos" . -x "*.git*"

echo ""
echo "=== Success! ==="
echo "Game bundle created: $GAME_DIR/epicpin.jsdos"
rm -rf "$TEMP_DIR"
