#!/bin/bash

front_app=(
	script="$PLUGIN_DIR/front_app.sh"
	icon.drawing=on
	icon=""
	icon.background.drawing=on
	icon.background.color=$TRANSPARENT
	icon.background.image.scale=0.8
	icon.padding_right=0
	icon.padding_left=0
	padding_left=4
	padding_right=4
	label.drawing=on
	label.color=$WHITE
	label.font="$FONT:Bold:13.0"
	label.max_chars=70
	scroll_texts=on
	associated_display=active
	updates=on
)

sketchybar --add item front_app left \
	--set front_app "${front_app[@]}" \
	--subscribe front_app front_app_switched
