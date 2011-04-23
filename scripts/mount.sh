#!/bin/sh

MYUID=`id -u`
MYGID=`id -g`

if [ "$#" -lt "2" ] ; then
  echo "$0 <device> <dir>"
  exit 0
fi

CMD="mount"
if [ "$UID" != "0" ] ; then
  CMD="sudo $CMD"
fi

$CMD -o uid=$MYUID,gid=$MYGID "$1" "$2"

