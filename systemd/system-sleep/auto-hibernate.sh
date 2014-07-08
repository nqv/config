#!/bin/bash
# Script name: /lib/systemd/system-sleep/auto-hibernate
# Purpose: Auto hibernates after a period of sleep

# 60 minutes
TIMEOUT=3600
LOCK=/var/run/systemd/rtcwake_hibernate.lock

CURTIME=$(date +%s)

echo "$CURTIME $1" >> /tmp/auto_hibernate.log

if [ "$1" = "pre" ]; then
  if [ "$2" = "suspend" ]; then
    # Suspending. Record current time, and set a wake up timer.
    echo "$CURTIME" > "$LOCK"
    rtcwake --mode no --seconds $TIMEOUT
  fi
fi

if [ "$1" = "post" ]; then
  if [ "$2" = "suspend" ]; then
    # Coming out of sleep
    TIME=$(cat "$LOCK")
    rm "$LOCK"
    # Did we wake up due to the rtc timer above?
    if [ $(($CURTIME - $TIME)) -ge $TIMEOUT ]; then
      # Then hibernate
      /usr/bin/systemctl hibernate
    else
      # Otherwise cancel the rtc timer and wake up normally.
      rtcwake --mode no --seconds 1
    fi
  fi
fi
