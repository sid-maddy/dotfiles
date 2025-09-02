#!/usr/bin/env bash

# shellcheck source=./executable_colors.sh
source "$CONFIG_DIR/plugins/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
	sketchybar --set "$NAME" \
		background.border_color="$TEXT_GREY" \
		background.color="$TEXT_BLUE"
else
	sketchybar --set "$NAME" \
		background.border_color="$TEXT_WHITE" \
		background.color="$TRANSPARENT"
fi
