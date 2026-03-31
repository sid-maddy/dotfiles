#!/bin/bash

now_playing=(
	script="$PLUGIN_DIR/now_playing.sh"
	update_freq=3
	icon="♫"
	icon.font="$FONT:Bold:13.0"
	icon.padding_right=3
	icon.y_offset=0
	label.font="$FONT:Bold:13.0"
	label.max_chars=70
	scroll_texts=on
	padding_left=4
	padding_right=4
	drawing=off
	updates=on
	popup.drawing=off
	popup.background.color=0xdd0d1017
	popup.background.corner_radius=10
	popup.background.border_width=1
	popup.background.border_color=$GREY
	popup.align=center
	popup.height=25
)

sketchybar --add item now_playing right \
	--set now_playing "${now_playing[@]}" \
	--subscribe now_playing mouse.entered mouse.exited

sketchybar --add item now_playing.album popup.now_playing \
	--set now_playing.album \
	icon.drawing=off \
	label.font="$FONT:Bold:12.0" \
	label.color=$WHITE \
	padding_left=8 \
	padding_right=8

sketchybar --add item now_playing.artist popup.now_playing \
	--set now_playing.artist \
	icon.drawing=off \
	label.font="$FONT:Bold:12.0" \
	label.color=$WHITE \
	padding_left=8 \
	padding_right=8
