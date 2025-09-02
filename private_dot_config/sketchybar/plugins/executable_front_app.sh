#!/usr/bin/env bash

# shellcheck source=./executable_colors.sh
source "$CONFIG_DIR/plugins/colors.sh"

# Some events send additional information specific to the event in the $INFO variable.
# E.g. the front_app_switched event sends the name of the newly focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

if [ "$SENDER" = "front_app_switched" ]; then
	front_app=(
		icon.background.color="$TRANSPARENT"
		icon.background.drawing=on
		icon.background.image="app.$(osascript -e "get id of app \"$INFO\"")"
		icon.background.image.scale=0.75
		icon.padding_right=15

		label="$INFO"
	)
	sketchybar --set "$NAME" "${front_app[@]}"
fi
