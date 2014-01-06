#!/bin/bash
DISPLAYS=("LVDS1" "VGA1")

PREV=""
ARGS=""

swauto() {
  ARGS="$ARGS --output $1 --auto"
}

swoff() {
  ARGS="$ARGS --output $1 --off"
}

swrightof() {
  ARGS="$ARGS --right-of $1"
}

for D in "$@"; do
  # Check if first character is '-'
  if [ "${D:0:1}" = "-" ]; then
    D="${DISPLAYS[${D:1}]}"
    if [ ! -z "$D" ]; then
      swoff "$D"
    fi
  else
    D="${DISPLAYS[$D]}"
    if [ ! -z "$D" ]; then
      swauto "$D"
      if [ ! -z "$PREV" ]; then
        swrightof "$PREV"
      fi
      PREV="$D"
    fi
  fi
done

if [ ! -z "$ARGS" ]; then
  echo "$ARGS"
  xrandr $ARGS
fi
