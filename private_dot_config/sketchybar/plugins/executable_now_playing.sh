#!/bin/bash

source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
mouse.entered)
	sketchybar --set now_playing popup.drawing=on
	;;
mouse.exited | mouse.exited.global)
	sketchybar --set now_playing popup.drawing=off
	;;
*)
	INFO=$(media-control get 2>/dev/null)
	[ -z "$INFO" ] && { sketchybar --set now_playing drawing=off; exit 0; }

	PLAYING=$(echo "$INFO" | jq -r '.playing // false')
	if [ "$PLAYING" != "true" ]; then
		sketchybar --set now_playing drawing=off
		exit 0
	fi

	TITLE=$(echo "$INFO" | jq -r '.title // empty')
	ARTIST=$(echo "$INFO" | jq -r '.artist // empty')
	ALBUM=$(echo "$INFO" | jq -r '.album // empty')

	[ -z "$TITLE" ] && { sketchybar --set now_playing drawing=off; exit 0; }

	sketchybar --set now_playing drawing=on label="$TITLE" \
		--set now_playing.artist label="${ARTIST:+Artist: $ARTIST}" \
		--set now_playing.album label="${ALBUM:+Album: $ALBUM}"
	;;
esac
