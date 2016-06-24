#!/bin/sh
# /usr/lib/systemd/system-sleep/suspend-sedation.sh

# 60 minutes
TIMEOUT=3600
WAKEALARM=/sys/class/rtc/rtc0/wakealarm

if [ "$1" = "pre" -a "$2" = "suspend" ]; then
  /usr/sbin/rtcwake --seconds $TIMEOUT --auto --mode no
fi

if [ "$1" = "post" -a "$2" = "suspend" ]; then
  ALARM=$(cat $WAKEALARM)
  NOW=$(date +%s)
  if [ -z "$ALARM" ] || [ "$NOW" -ge "$ALARM" ]; then
    echo "$NOW" "hibernate" >> /tmp/suspend-sedation.log
    /usr/sbin/systemctl hibernate
  else
    echo "$NOW" "wakeup" >> /tmp/suspend-sedation.log
    /usr/sbin/rtcwake --auto --mode disable
  fi
fi
