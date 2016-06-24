#!/bin/sh
# Script: /lib/systemd/system-sleep/drop-caches.sh

if [ "$1" = "pre" -a "$2" = "hibernate" ]; then
  sync
  echo 3 > /proc/sys/vm/drop_caches
fi
