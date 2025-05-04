#!/usr/bin/env bash

# NOT IN USE
space=(
	background.color=0X44FFFFFF
	background.corner_radius=5
	background.drawing=off
	background.height=20
	click_script="aerospace workspace $sid"
	label="$sid"
	script="$CONFIG_DIR/plugins/aerospace.sh $sid"
)
for sid in $(aerospace list-workspaces --monitor 1 --empty no); do
	sketchybar --add item space."$sid" left \
		--set space."$sid" "${space[@]}" \
		--subscribe space."$sid" aerospace_workspace_change
done
