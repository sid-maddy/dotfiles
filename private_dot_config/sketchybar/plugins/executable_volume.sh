#!/bin/bash

source "$CONFIG_DIR/colors.sh"

get_volume() {
	osascript -e "output volume of (get volume settings)" 2>/dev/null
}

get_devices() {
	system_profiler SPAudioDataType 2>/dev/null | awk '
		/^        [^ ]/ { gsub(/:$/,""); name=$0; gsub(/^ +/,"",name) }
		/Default Output Device: Yes/ { out=name }
		/Default Input Device: Yes/  { inp=name }
		END { print out "|" inp }
	'
}

case "$SENDER" in
mouse.entered)
	IFS='|' read -r OUTPUT INPUT <<< "$(get_devices)"
	[ -z "$OUTPUT" ] && OUTPUT="N/A"
	[ -z "$INPUT" ] && INPUT="N/A"
	sketchybar \
		--set volume.output label="Out: $OUTPUT" \
		--set volume.input label="In: $INPUT" \
		--set volume popup.drawing=on
	;;
mouse.exited | mouse.exited.global)
	sketchybar --set volume popup.drawing=off
	;;
*)
	if [ "$SENDER" = "volume_change" ]; then
		VOLUME="$INFO"
	else
		VOLUME="$(get_volume)"
	fi

	[ -z "$VOLUME" ] && exit 0

	case "$VOLUME" in
	[6-9][0-9] | 100) ICON="󰕾" ;;
	[3-5][0-9]) ICON="󰖀" ;;
	[1-9] | [1-2][0-9]) ICON="󰕿" ;;
	*) ICON="󰖁" ;;
	esac

	sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%"
	;;
esac
