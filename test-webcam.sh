#!/bin/bash
DEVICE=${1:-/dev/video0}
mplayer tv:// -tv driver=v4l2:width=640:height=480:device=$DEVICE -fps 30
