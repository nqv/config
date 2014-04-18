#!/bin/sh
DIR="$1"

if [ -z "$DIR" ]; then
  echo "$0 <DIR>"
  exit 1
fi

getstat() {
  stat --file-system --format="%T" "$1"
}

STAT=`getstat "$DIR/proc"`
if [ "$STAT" != "proc" ]; then
  mount proc  "$DIR/proc" -t proc
fi

STAT=`getstat "$DIR/sys"`
if [ "$STAT" != "sysfs" ]; then
  mount sysfs "$DIR/sys"  -t sysfs
fi

chroot "$DIR"
