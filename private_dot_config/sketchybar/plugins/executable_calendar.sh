#!/bin/bash

source "$CONFIG_DIR/colors.sh"

INFO=$(osascript -e '
tell application "System Events"
	if exists process "Notion Calendar" then
		tell process "Notion Calendar"
			return name of menu bar item 1 of menu bar 2
		end tell
	end if
	return ""
end tell
' 2>/dev/null)

if [ -z "$INFO" ]; then
	sketchybar --set calendar drawing=off
	exit 0
fi

sketchybar --set calendar drawing=on label="$INFO"
