#!/usr/bin/env bash

# shellcheck source=./executable_colors.sh
source "$CONFIG_DIR/plugins/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
	exit 0
fi

case "$PERCENTAGE" in
9[0-9] | 100)
	ICON=""
	COLOUR="$TEXT_WHITE"
	;;
[6-8][0-9])
	ICON=""
	COLOUR="$TEXT_WHITE"
	;;
[3-5][0-9])
	ICON=""
	COLOUR="$TEXT_ORANGE"
	;;
[1-2][0-9])
	ICON=""
	COLOUR="$TEXT_RED"
	;;
[0-9])
	ICON=""
	COLOUR="$TEXT_RED"
	;;
esac

if [[ "$CHARGING" != "" ]]; then
	ICON=""
fi

# The item invoking this script (name $NAME) will get its icon and label updated with the current battery status
sketchybar --set "$NAME" \
	icon.color="$COLOUR" \
	icon="$ICON" \
	label.color="$COLOUR" \
	label="${PERCENTAGE}%"
