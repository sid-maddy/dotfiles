#!/usr/bin/env bash

# The $SELECTED variable is available for space components and indicates if the space invoking this script (name: $NAME)
# is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

sketchybar --set "$NAME" background.drawing="$SELECTED"
