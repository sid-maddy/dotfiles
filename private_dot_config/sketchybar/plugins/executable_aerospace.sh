#!/usr/bin/env bash

# shellcheck source=./executable_colors.sh
source "$CONFIG_DIR/plugins/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
	sketchybar --set "$NAME" \
		background.border_color="$TEXT_GREY" \
		background.color="$HIGHLIGHT_BACKGROUND" \
		icon.color="$TEXT_WHITE" \
		label.color="$TEXT_WHITE"
else
	sketchybar --set "$NAME" \
		background.border_color="$TEXT_WHITE" \
		background.color="$TRANSPARENT" \
		icon.color="$TEXT_WHITE" \
		label.color="$TEXT_WHITE"
fi
