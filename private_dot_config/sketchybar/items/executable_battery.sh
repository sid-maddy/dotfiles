#!/bin/bash

battery=(
	script="$PLUGIN_DIR/battery.sh"
	update_freq=120
	icon.font="$ICON_FONT:Regular:15.0"
	icon.padding_right=3
	icon.y_offset=1
	label.font="$FONT:Bold:13.0"
	padding_right=4
	padding_left=4
	updates=on
	popup.drawing=off
	popup.background.color=0xdd0d1017
	popup.background.corner_radius=10
	popup.background.border_width=1
	popup.background.border_color=$GREY
	popup.align=center
	popup.height=25
)

sketchybar --add item battery right \
	--set battery "${battery[@]}" \
	--subscribe battery power_source_change system_woke mouse.entered mouse.exited

sketchybar --add item battery.source popup.battery \
	--set battery.source \
	icon.drawing=off \
	label.font="$FONT:Bold:12.0" \
	label.color=$WHITE \
	padding_left=8 \
	padding_right=8

sketchybar --add item battery.remaining popup.battery \
	--set battery.remaining \
	icon.drawing=off \
	label.font="$FONT:Bold:12.0" \
	label.color=$WHITE \
	padding_left=8 \
	padding_right=8
