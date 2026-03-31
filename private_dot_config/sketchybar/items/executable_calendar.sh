#!/bin/bash

calendar=(
	script="$PLUGIN_DIR/calendar.sh"
	update_freq=30
	icon="󰃭"
	icon.font="$ICON_FONT:Regular:15.0"
	icon.padding_right=3
	icon.y_offset=1
	label.font="$FONT:Bold:13.0"
	label.max_chars=40
	scroll_texts=on
	padding_left=4
	padding_right=4
	drawing=off
	updates=on
)

sketchybar --add item calendar right \
	--set calendar "${calendar[@]}"
