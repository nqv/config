#!/bin/bash

ss_on() {
  xset s on
  xset +dpms
}

ss_off() {
  xset s off
  xset -dpms
}

quit() {
  ss_on
  echo "Screensaver enabled"
  exit 0
}

trap quit INT

ss_off
echo "Screensaver disabled"

while true; do
  sleep 60
  echo -n "."
done

