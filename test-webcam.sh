#!/bin/bash
DEVICE=${1:-/dev/video0}
mpv --profile=low-latency av://v4l2:$DEVICE
