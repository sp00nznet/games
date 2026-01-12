#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GAME_DIR="$SCRIPT_DIR/../game"
TEMP_DIR="$SCRIPT_DIR/../temp"
echo "=== Virtual Pool Download Script ==="
mkdir -p "$GAME_DIR" "$TEMP_DIR"
ARCHIVE_URL="https://archive.org/download/msdos_Virtual_Pool_1995/Virtual%20Pool%20%281995%29%28Interplay%29.zip"
echo "Downloading..."
curl -L -f -o "$TEMP_DIR/game.zip" "$ARCHIVE_URL" || { echo "Download failed. Get from: https://archive.org/details/msdos_Virtual_Pool_1995"; exit 1; }
cd "$TEMP_DIR" && unzip -o game.zip -d extract
GAME_FOLDER=$(find extract -type f -iname "*.exe" -exec dirname {} \; | head -1)
cat > dosbox.conf << 'CONF'
[autoexec]
mount c .
c:
CONF
find "$GAME_FOLDER" -maxdepth 1 -iname "*.exe" | head -1 | xargs basename >> dosbox.conf
mkdir -p jsdos/.jsdos && cp dosbox.conf jsdos/.jsdos/ && cp -r "$GAME_FOLDER"/* jsdos/
cd jsdos && zip -r "$GAME_DIR/vpool.jsdos" .
rm -rf "$TEMP_DIR"
echo "Created: $GAME_DIR/vpool.jsdos"
