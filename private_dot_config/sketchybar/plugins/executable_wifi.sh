#!/usr/bin/env bash

if [ "$SENDER" = "wifi_change" ] || [ "$SENDER" = "forced" ]; then
	priv_ipaddr="$(networksetup -getinfo Wi-Fi | grep "IP address" | head -n 1 | awk -F ':' '{print $2}')" # 0.0.0.0 | none | -empty-
	ssid="$(ipconfig getsummary "$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}')" | awk -F ' SSID : ' '/ SSID : / {print $2}')"

	icon=""
	if [ -n "$priv_ipaddr" ] && [ "$priv_ipaddr" != " none" ]; then
		icon=""
	else
		icon=""
		ssid="-offline-"
	fi

	sketchybar --set wifi icon="$icon" label="$ssid"
fi
