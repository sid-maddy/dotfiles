#!/usr/bin/env bash

if [ "$SENDER" = "front_app_switched" ]; then
	WINDOW_TITLE=$(osascript -e "tell application \"System Events\" to tell process \"$INFO\" to get name of front window" 2>/dev/null)
	if [ -n "$WINDOW_TITLE" ]; then
		LABEL="$INFO · $WINDOW_TITLE"
	else
		LABEL="$INFO"
	fi
	sketchybar --set "$NAME" icon.background.image="app.$INFO" label="$LABEL"

	CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
	AEROSPACE_BIN="${AEROSPACE_BIN:-$(command -v aerospace 2>/dev/null || true)}"
	[ -z "$AEROSPACE_BIN" ] && exit 0

	FOCUSED_WS="$("$AEROSPACE_BIN" list-workspaces --focused 2>/dev/null | head -1)"
	[ -z "$FOCUSED_WS" ] && exit 0

	APP_COLOR="$("$CONFIG_DIR/helpers/app_color.sh" "$INFO")"
	DIM_COLOR="0x20${APP_COLOR:4}"
	sketchybar --animate tanh 20 \
		--set "space.$FOCUSED_WS" \
		background.border_color="$APP_COLOR" \
		background.color="$DIM_COLOR"
fi
