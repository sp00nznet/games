#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GAME_DIR="$SCRIPT_DIR/../game"
TEMP_DIR="$SCRIPT_DIR/../temp"
echo "=== Shadow Warrior Download Script ==="
mkdir -p "$GAME_DIR" "$TEMP_DIR"
ARCHIVE_URL="https://archive.org/download/msdos_Shadow_Warrior_1997/Shadow%20Warrior%20%281997%29%283D%20Realms%29.zip"
echo "Downloading..."
curl -L -f -o "$TEMP_DIR/game.zip" "$ARCHIVE_URL" || { echo "Download failed. Get from: https://archive.org/details/msdos_Shadow_Warrior_1997"; exit 1; }
cd "$TEMP_DIR" && unzip -o game.zip -d extract
GAME_FOLDER=$(find extract -type f -iname "*.exe" -exec dirname {} \; | head -1)
cat > dosbox.conf << 'CONF'
[cpu]
cycles=max
[autoexec]
mount c .
c:
CONF
find "$GAME_FOLDER" -maxdepth 1 -iname "sw*.exe" -o -iname "*.exe" | head -1 | xargs basename >> dosbox.conf
mkdir -p jsdos/.jsdos && cp dosbox.conf jsdos/.jsdos/ && cp -r "$GAME_FOLDER"/* jsdos/
cd jsdos && zip -r "$GAME_DIR/sw.jsdos" .
rm -rf "$TEMP_DIR"
echo "Created: $GAME_DIR/sw.jsdos"
