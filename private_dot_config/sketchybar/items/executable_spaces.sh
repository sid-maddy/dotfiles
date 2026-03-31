#!/bin/bash

WORKSPACES=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

for sid in "${WORKSPACES[@]}"; do
	space=(
		icon="●"
		icon.font="$FONT:Bold:7.0"
		icon.color=$RED
		icon.drawing=off
		icon.padding_left=0
		icon.padding_right=2
		padding_left=0
		padding_right=0
		width=0
		label.font="sketchybar-app-font:Regular:14.0"
		label.color=$GREY
		label.y_offset=0
		label.drawing=off
		background.drawing=on
		background.height=22
		background.corner_radius=6
		background.y_offset=0
		background.color=$TRANSPARENT
		background.border_width=1
		background.border_color=$TRANSPARENT
		shadow.drawing=off
		updates=on
		click_script="aerospace workspace $sid"
	)

	sketchybar --add item "space.$sid" left \
		--set "space.$sid" "${space[@]}"

	sketchybar --add item "space.sep.$sid" left \
		--set "space.sep.$sid" \
		icon="·" \
		icon.font="$FONT:Bold:10.0" \
		icon.color=$GREY \
		icon.padding_left=1 \
		icon.padding_right=1 \
		padding_left=0 \
		padding_right=0 \
		width=0 \
		drawing=off \
		label.drawing=off
done

spaces_updater=(
	script="$PLUGIN_DIR/spaces_update.sh"
	drawing=off
	icon.drawing=off
	label.drawing=off
	width=0
	update_freq=30
	updates=on
)

sketchybar --add item spaces.updater left \
	--set spaces.updater "${spaces_updater[@]}" \
	--subscribe spaces.updater aerospace_workspace_change \
	system_woke front_app_switched

sketchybar --trigger aerospace_workspace_change
