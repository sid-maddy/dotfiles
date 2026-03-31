#!/opt/homebrew/bin/bash

PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
CACHE_FILE="/tmp/sketchybar_spaces_state"

AEROSPACE_BIN="${AEROSPACE_BIN:-$(command -v aerospace 2>/dev/null || true)}"
SKETCHYBAR_BIN="${SKETCHYBAR_BIN:-$(command -v sketchybar 2>/dev/null || true)}"

if [ -z "$AEROSPACE_BIN" ] || [ -z "$SKETCHYBAR_BIN" ]; then
	exit 0
fi

# shellcheck source=../helpers/executable_icon_map.sh
source "$CONFIG_DIR/helpers/icon_map.sh"
source "$CONFIG_DIR/colors.sh"

WORKSPACES=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

trim() {
	local value="$1"
	value="${value#"${value%%[![:space:]]*}"}"
	value="${value%"${value##*[![:space:]]}"}"
	printf "%s" "$value"
}

focused_workspace() {
	if [ -n "${FOCUSED_WORKSPACE:-}" ]; then
		trim "$FOCUSED_WORKSPACE"
		return 0
	fi
	"$AEROSPACE_BIN" list-workspaces --focused 2>/dev/null | head -n 1
}

fetch_all_window_data() {
	ALL_WINDOWS_RAW="$("$AEROSPACE_BIN" list-windows --all --format '%{workspace}|%{app-name}' 2>/dev/null || true)"

	local ws
	ACTIVE_SET=" "
	while IFS='|' read -r ws _; do
		ws="$(trim "$ws")"
		[ -n "$ws" ] || continue
		case "$ACTIVE_SET" in
		*" $ws "*) ;;
		*) ACTIVE_SET="${ACTIVE_SET}${ws} " ;;
		esac
	done <<<"$ALL_WINDOWS_RAW"
}

workspace_icons() {
	local workspace="$1"
	local ws app
	ICONS_RESULT=""
	WINDOW_COUNT=0
	UNIQUE_APP_COUNT=0
	local -a unique_apps=()
	local -A seen_apps=()

	while IFS='|' read -r ws app; do
		ws="$(trim "$ws")"
		[ "$ws" = "$workspace" ] || continue
		app="$(trim "$app")"
		app="${app%\"}"
		app="${app#\"}"
		[ -n "$app" ] || continue
		((WINDOW_COUNT++))
		if [ -z "${seen_apps[$app]:-}" ]; then
			seen_apps[$app]=1
			unique_apps+=("$app")
		fi
	done <<<"$ALL_WINDOWS_RAW"

	UNIQUE_APP_COUNT=${#unique_apps[@]}

	IFS=$'\n' read -r -d '' -a unique_apps < <(printf '%s\n' "${unique_apps[@]}" | sort -f && printf '\0') || true

	for app in "${unique_apps[@]}"; do
		__icon_map "$app"
		ICONS_RESULT="${ICONS_RESULT}${icon_result:-:default:}"
	done
}

update_focus_only() {
	local focused="$1"
	local -a args
	args=()

	for sid in "${WORKSPACES[@]}"; do
		case "$ACTIVE_SET" in
		*" $sid "*)
			if [ "$sid" = "$focused" ]; then
				args+=(--animate tanh 20 --set "space.$sid"
					label.color="$WHITE")
			else
				args+=(--animate tanh 20 --set "space.$sid"
					label.color="$GREY"
					background.color="$TRANSPARENT"
					background.border_color="$TRANSPARENT")
			fi
			;;
		esac
	done

	[ "${#args[@]}" -gt 0 ] && "$SKETCHYBAR_BIN" -m "${args[@]}"
}

full_update() {
	local focused="$1"
	local sid
	local -a visible_sids layout_args color_args

	visible_sids=()
	layout_args=()
	color_args=()

	for sid in "${WORKSPACES[@]}"; do
		ICONS_RESULT=""

		case "$ACTIVE_SET" in
		*" $sid "*)
			workspace_icons "$sid"
			[ -n "$ICONS_RESULT" ] || ICONS_RESULT=":default:"
			visible_sids+=("$sid")

			layout_args+=(--set "space.$sid"
				drawing=on width=dynamic
				padding_left=4 padding_right=4
				label="$ICONS_RESULT"
				label.drawing=on label.width=dynamic)

			# Colors: animated, separate call
			if [ "$sid" = "$focused" ]; then
				color_args+=(--animate tanh 20 --set "space.$sid"
					label.color="$WHITE")
			else
				color_args+=(--animate tanh 20 --set "space.$sid"
					label.color="$GREY"
					background.color="$TRANSPARENT"
					background.border_color="$TRANSPARENT")
			fi
			;;
		*)
			layout_args+=(--set "space.$sid"
				drawing=off width=0
				padding_left=0 padding_right=0
				label="" label.drawing=off label.width=0)
			;;
		esac

		layout_args+=(--set "space.sep.$sid" drawing=off width=0)
	done

	local i
	for ((i = 0; i < ${#visible_sids[@]} - 1; i++)); do
		layout_args+=(--set "space.sep.${visible_sids[$i]}" drawing=on width=dynamic)
	done

	# Apply layout instantly first, then animate colors
	[ "${#layout_args[@]}" -gt 0 ] && "$SKETCHYBAR_BIN" -m "${layout_args[@]}"
	[ "${#color_args[@]}" -gt 0 ] && "$SKETCHYBAR_BIN" -m "${color_args[@]}"
}

has_badge() {
	local status
	status="$(lsappinfo info -only StatusLabel "$1" 2>/dev/null)"
	case "$status" in
	*'"label"="'*)
		case "$status" in
		*'kCFNULL'*) return 1 ;;
		*) return 0 ;;
		esac
		;;
	*) return 1 ;;
	esac
}

apply_notification_dots() {
	local -a args=()
	local ws app sid has_notif

	for sid in "${WORKSPACES[@]}"; do
		case "$ACTIVE_SET" in
		*" $sid "*)
			has_notif=0
			while IFS='|' read -r ws app; do
				ws="$(trim "$ws")"
				[ "$ws" = "$sid" ] || continue
				app="$(trim "$app")"
				app="${app%\"}"
				app="${app#\"}"
				[ -n "$app" ] || continue
				if has_badge "$app"; then
					has_notif=1
					break
				fi
			done <<<"$ALL_WINDOWS_RAW"

			if [ "$has_notif" -eq 1 ]; then
				args+=(--set "space.$sid" icon.drawing=on)
			else
				args+=(--set "space.$sid" icon.drawing=off)
			fi
			;;
		esac
	done

	[ "${#args[@]}" -gt 0 ] && "$SKETCHYBAR_BIN" -m "${args[@]}"
}

apply_app_border_color() {
	local focused="$1"
	local front_app="${2:-}"
	[ -z "$front_app" ] && front_app="$("$AEROSPACE_BIN" list-windows --focused --format '%{app-name}' 2>/dev/null | head -1)"
	[ -z "$front_app" ] && return
	local app_color
	app_color="$("$CONFIG_DIR/helpers/app_color.sh" "$front_app")"
	local dim_color="0x20${app_color:4}"
	"$SKETCHYBAR_BIN" --animate tanh 20 \
		--set "space.$focused" \
		background.border_color="$app_color" \
		background.color="$dim_color"
}

update_spaces() {
	local focused front_app
	focused="$(focused_workspace)"
	front_app="$("$AEROSPACE_BIN" list-windows --focused --format '%{app-name}' 2>/dev/null | head -1)"
	fetch_all_window_data

	local prev_active_set=""
	[ -f "$CACHE_FILE" ] && prev_active_set="$(cat "$CACHE_FILE")"
	printf "%s" "$ACTIVE_SET" >"$CACHE_FILE"

	local windows_sig
	windows_sig="$(printf '%s' "$ALL_WINDOWS_RAW" | sort)"
	local WINDOWS_CACHE="/tmp/sketchybar_windows_sig"
	local prev_windows_sig=""
	[ -f "$WINDOWS_CACHE" ] && prev_windows_sig="$(cat "$WINDOWS_CACHE")"
	printf '%s' "$windows_sig" >"$WINDOWS_CACHE"

	if [ "$prev_active_set" = "$ACTIVE_SET" ] && [ "$prev_windows_sig" = "$windows_sig" ]; then
		update_focus_only "$focused"
	else
		full_update "$focused"
	fi

	apply_notification_dots
	apply_app_border_color "$focused" "$front_app"
}

update_spaces
