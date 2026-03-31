#!/bin/bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
mouse.entered)
	sketchybar --set battery popup.drawing=on
	;;
mouse.exited | mouse.exited.global)
	sketchybar --set battery popup.drawing=off
	;;
*)
	BATT_INFO=$(pmset -g batt)
	PERCENTAGE=$(echo "$BATT_INFO" | grep -Eo "\d+%" | cut -d% -f1)
	CHARGING=$(echo "$BATT_INFO" | grep 'AC Power')

	if [ -z "$PERCENTAGE" ]; then
		exit 0
	fi

	case ${PERCENTAGE} in
	9[0-9] | 100) ICON=$BATTERY_100 COLOR=$GREEN ;;
	[6-8][0-9]) ICON=$BATTERY_75 COLOR=$WHITE ;;
	[3-5][0-9]) ICON=$BATTERY_50 COLOR=$YELLOW ;;
	[1-2][0-9]) ICON=$BATTERY_25 COLOR=$ORANGE ;;
	*) ICON=$BATTERY_0 COLOR=$RED ;;
	esac

	if [[ -n "$CHARGING" ]]; then
		ICON=$BATTERY_CHARGING
		COLOR=$GREEN
		SOURCE="AC Power"
		TIME_LABEL=$(echo "$BATT_INFO" | grep -Eo "\d+:\d+" || echo "")
		if [ "$PERCENTAGE" -eq 100 ]; then
			TIME_LABEL="Fully Charged"
		elif [ -n "$TIME_LABEL" ]; then
			TIME_LABEL="${TIME_LABEL} until full"
		else
			TIME_LABEL="Charging"
		fi
	else
		SOURCE="Battery"
		TIME_LABEL=$(echo "$BATT_INFO" | grep -Eo "\d+:\d+ remaining" || echo "Calculating...")
	fi

	sketchybar --set "$NAME" \
		icon="$ICON" \
		icon.color="$COLOR" \
		label="${PERCENTAGE}%" \
		label.color="$COLOR" \
		--set battery.source label="Source: $SOURCE" \
		--set battery.remaining label="$TIME_LABEL"
	;;
esac
