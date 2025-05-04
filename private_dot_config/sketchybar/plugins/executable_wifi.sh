#!/usr/bin/env bash

if [ "$SENDER" = "wifi_change" ] || [ "$SENDER" = "forced" ]; then
	priv_ipaddr="$(networksetup -getinfo Wi-Fi | grep "IP address" | head -n 1 | awk -F ':' '{print $2}')" # 0.0.0.0 | none
	ssid="$(system_profiler SPAirPortDataType | awk '/Current Network Information:/ { getline; print substr($0, 13, (length($0) - 13)); exit }')"

	icon=""
	if [ "$priv_ipaddr" != " none" ]; then
		icon="󰄍"
	else
		icon=""
		ssid="-offline-"
	fi

	sketchybar --set wifi icon="$icon" label="$ssid"
fi
