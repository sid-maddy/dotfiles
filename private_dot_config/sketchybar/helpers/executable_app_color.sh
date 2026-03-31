#!/bin/bash
# Usage: app_color.sh "AppName"

APP_NAME="$1"
FALLBACK="0xff59c2ff"
[ -z "$APP_NAME" ] && echo "$FALLBACK" && exit 0

CACHE_DIR="/tmp/sketchybar_color_cache"
mkdir -p "$CACHE_DIR"
CACHE_KEY="$(echo "$APP_NAME" | tr '/ ' '__')"
CACHE_FILE="$CACHE_DIR/$CACHE_KEY"

if [ -f "$CACHE_FILE" ]; then
	cat "$CACHE_FILE"
	exit 0
fi

APP_PATH=""
for dir in "/Applications" "/System/Applications" "/System/Applications/Utilities" "$HOME/Applications" "/Applications/Utilities"; do
	if [ -d "$dir/$APP_NAME.app" ]; then
		APP_PATH="$dir/$APP_NAME.app"
		break
	fi
done

if [ -z "$APP_PATH" ]; then
	APP_PATH="$(mdfind "kMDItemKind == 'Application' && kMDItemDisplayName == '$APP_NAME'" 2>/dev/null | head -1)"
fi

if [ -z "$APP_PATH" ] || [ ! -d "$APP_PATH" ]; then
	echo "$FALLBACK" >"$CACHE_FILE"
	echo "$FALLBACK"
	exit 0
fi

ICON_FILE="$(defaults read "$APP_PATH/Contents/Info" CFBundleIconFile 2>/dev/null || echo "")"
[ -z "$ICON_FILE" ] && ICON_FILE="AppIcon"
[[ "$ICON_FILE" == *.icns ]] || ICON_FILE="$ICON_FILE.icns"
ICON_PATH="$APP_PATH/Contents/Resources/$ICON_FILE"

if [ ! -f "$ICON_PATH" ]; then
	echo "$FALLBACK" >"$CACHE_FILE"
	echo "$FALLBACK"
	exit 0
fi

TMP_BMP="/tmp/sketchybar_icon_$$.bmp"
sips -s format bmp -z 32 32 "$ICON_PATH" --out "$TMP_BMP" &>/dev/null

SCRIPT_DIR="$(dirname "$0")"
COLOR="$(python3 "$SCRIPT_DIR/extract_color.py" "$TMP_BMP" 2>/dev/null || echo "$FALLBACK")"
rm -f "$TMP_BMP"

echo "$COLOR" >"$CACHE_FILE"
echo "$COLOR"
