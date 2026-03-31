#!/bin/bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

case "$SENDER" in
mouse.entered)
	sketchybar --set wifi popup.drawing=on
	;;
mouse.exited | mouse.exited.global)
	sketchybar --set wifi popup.drawing=off
	;;
*)
	SSID=$(get-ssid 2>/dev/null)

	if [ -n "$SSID" ] && [ "$SSID" != "Unknown (not associated)" ]; then
		ICON=$WIFI_CONNECTED
		LABEL="$SSID"
		COLOR=$WHITE
		IP=$(ipconfig getifaddr en0 2>/dev/null || echo "N/A")
		ROUTER=$(networksetup -getinfo Wi-Fi 2>/dev/null | grep "^Router" | awk -F': ' '{print $2}')
		[ -z "$ROUTER" ] && ROUTER="N/A"
	else
		ICON=$WIFI_DISCONNECTED
		LABEL="Off"
		COLOR=$RED
		IP="N/A"
		ROUTER="N/A"
	fi

	sketchybar --set "$NAME" \
		icon="$ICON" \
		icon.color="$COLOR" \
		label="$LABEL" \
		label.color="$COLOR" \
		--set wifi.ip label="IP: $IP" \
		--set wifi.router label="Router: $ROUTER"
	;;
esac
