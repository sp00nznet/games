#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GAME_DIR="$SCRIPT_DIR/../game"
TEMP_DIR="$SCRIPT_DIR/../temp"
echo "=== Mario Teaches Typing Download Script ==="
mkdir -p "$GAME_DIR" "$TEMP_DIR"
ARCHIVE_URL="https://archive.org/download/TYPING_EGA/TYPING_EGA.zip"
echo "Downloading..."
curl -L -f -o "$TEMP_DIR/game.zip" "$ARCHIVE_URL" || { echo "Download failed. Get from: https://archive.org/details/TYPING_EGA"; exit 1; }
cd "$TEMP_DIR" && unzip -o game.zip -d extract
GAME_FOLDER=$(find extract -type f -iname "*.exe" -exec dirname {} \; | head -1)
[ -z "$GAME_FOLDER" ] && GAME_FOLDER="$TEMP_DIR/extract"
cat > dosbox.conf << 'CONF'
[autoexec]
mount c .
c:
CONF
find "$GAME_FOLDER" -maxdepth 2 -iname "*.exe" 2>/dev/null | head -1 | xargs basename >> dosbox.conf 2>/dev/null || echo "typing.exe" >> dosbox.conf
mkdir -p jsdos/.jsdos && cp dosbox.conf jsdos/.jsdos/ && cp -r "$GAME_FOLDER"/* jsdos/ 2>/dev/null || cp -r extract/* jsdos/
cd jsdos && zip -r "$GAME_DIR/typing.jsdos" .
rm -rf "$TEMP_DIR"
echo "Created: $GAME_DIR/typing.jsdos"
