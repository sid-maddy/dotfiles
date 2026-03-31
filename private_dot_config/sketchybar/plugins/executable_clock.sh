#!/bin/bash

case "$SENDER" in
    mouse.entered)
        sketchybar --set clock popup.drawing=on
        ;;
    mouse.exited|mouse.exited.global)
        sketchybar --set clock popup.drawing=off
        ;;
    *)
        sketchybar --set clock label="$(date '+%H:%M')"
        sketchybar --set clock.date label="$(date '+%A, %d %B %Y') · Week $(date '+%V')"
        ;;
esac
