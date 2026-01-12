#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GAME_DIR="$SCRIPT_DIR/../game"
TEMP_DIR="$SCRIPT_DIR/../temp"
echo "=== Jazz Jackrabbit (1994) Download Script ==="
mkdir -p "$GAME_DIR" "$TEMP_DIR"
ARCHIVE_URL="https://archive.org/download/msdos_Jazz_Jackrabbit_1994/Jazz%20Jackrabbit%20%281994%29%28Epic%20MegaGames%2C%20Inc.%29.zip"
echo "Downloading..."
curl -L -f -o "$TEMP_DIR/game.zip" "$ARCHIVE_URL" || { echo "Download failed. Get from: https://archive.org/details/msdos_Jazz_Jackrabbit_1994"; exit 1; }
cd "$TEMP_DIR" && unzip -o game.zip -d extract
GAME_FOLDER=$(find extract -type f -iname "*.exe" -exec dirname {} \; | head -1)
cat > dosbox.conf << 'CONF'
[cpu]
cycles=max
[sblaster]
sbtype=sb16
[autoexec]
mount c .
c:
CONF
find "$GAME_FOLDER" -maxdepth 1 -iname "jazz*.exe" -o -iname "*.exe" | head -1 | xargs basename >> dosbox.conf
mkdir -p jsdos/.jsdos && cp dosbox.conf jsdos/.jsdos/ && cp -r "$GAME_FOLDER"/* jsdos/
cd jsdos && zip -r "$GAME_DIR/jazz94.jsdos" .
rm -rf "$TEMP_DIR"
echo "Created: $GAME_DIR/jazz94.jsdos"
