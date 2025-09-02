#!/usr/bin/env bash

# shellcheck source=../helpers/executable_icon_map.sh
source "$CONFIG_DIR/helpers/icon_map.sh"

for sid in $(aerospace list-workspaces --monitor all --empty); do
	sketchybar --set space."$sid" icon="" drawing=off
done

for sid in $(aerospace list-workspaces --monitor all --empty no); do
	apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

	sketchybar --set space."$sid" drawing=on

	icon_strip=" "
	if [ "${apps}" != "" ]; then
		while read -r app; do
			__icon_map "$app"
			icon_strip+=" $icon_result"
		done <<<"${apps}"
	else
		icon_strip=""
	fi

	sketchybar --set space."$sid" icon="$icon_strip"
done

if [ "$SENDER" == "aerospace_workspace_change" ] || [ "$SENDER" == "forced" ]; then
	sketchybar --set space."$FOCUSED_WORKSPACE" drawing=on
fi
