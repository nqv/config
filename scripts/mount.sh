#!/bin/sh

# Required an argument
if [ $# -lt 1 ]; then
  echo "$0 DEVICE [MOUNTDIR]"
  exit 0
fi

# Current user
MYUID=`id -u`
MYGID=`id -g`

SRC="$1"
TRG="$2"

if [ "$MYUID" = "0" ]; then
  SUDO=""
else
  SUDO="sudo"
fi

if [ -z "$TRG" ]; then
  # Create mount point in /media
  NAME=`basename "$SRC"`
  TRG="/media/$NAME"
  if [ ! -d "$TRG" ]; then
    $SUDO mkdir "$TRG"
  fi
fi

$SUDO mount -o uid=$MYUID,gid=$MYGID "$SRC" "$TRG"

