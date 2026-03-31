#!/bin/bash

PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
STATE_FILE="/tmp/sketchybar_focus_mode"
STATUS_ITEMS=(wifi volume battery)
WORKSPACES=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

AEROSPACE_BIN="${AEROSPACE_BIN:-$(command -v aerospace 2>/dev/null || true)}"
FOCUSED=$("$AEROSPACE_BIN" list-workspaces --focused 2>/dev/null | head -n 1)

if [ -f "$STATE_FILE" ]; then
	rm -f "$STATE_FILE"
	for item in "${STATUS_ITEMS[@]}"; do
		sketchybar --animate tanh 20 --set "$item" drawing=on
	done
	for sid in "${WORKSPACES[@]}"; do
		sketchybar --set "space.sep.$sid" drawing=on
	done
	rm -f /tmp/sketchybar_spaces_state
	sketchybar --trigger aerospace_workspace_change
else
	touch "$STATE_FILE"
	for item in "${STATUS_ITEMS[@]}"; do
		sketchybar --animate tanh 20 --set "$item" drawing=off
	done
	for sid in "${WORKSPACES[@]}"; do
		if [ "$sid" != "$FOCUSED" ]; then
			sketchybar --animate tanh 20 --set "space.$sid" drawing=off
		fi
		sketchybar --set "space.sep.$sid" drawing=off
	done
fi
