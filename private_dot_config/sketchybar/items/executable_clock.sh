#!/bin/bash

clock=(
	icon.drawing=off
	label.font="$FONT:Bold:13.0"
	padding_left=4
	padding_right=4
	update_freq=30
	script="$PLUGIN_DIR/clock.sh"
	click_script="$PLUGIN_DIR/focus_toggle.sh"
	popup.drawing=off
	popup.background.color=0xdd0d1017
	popup.background.corner_radius=10
	popup.background.border_width=1
	popup.background.border_color=$GREY
	popup.align=right
	popup.height=25
)

sketchybar --add item clock right \
	--set clock "${clock[@]}" \
	--subscribe clock system_woke mouse.entered mouse.exited

sketchybar --add item clock.date popup.clock \
	--set clock.date \
	icon.drawing=off \
	label.font="$FONT:Bold:13.0" \
	label.color=$WHITE \
	padding_left=8 \
	padding_right=8
