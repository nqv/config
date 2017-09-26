#!/bin/bash
OUT_DIR=.
OUT_FORMAT=mp3

MP3_OPTS="-vn -map_metadata 0:s:0 -codec:a libmp3lame -qscale:a 4"

###

while getopts "d:f:h" flag; do
  case $flag in
  o)
    OUT_FORMAT="$OPTARG"
    ;;
  d)
    OUT_DIR="$OPTARG"
    ;;
  h|*)
    echo "Usage: $0 [OPTION] <FILE>..."
    echo "  -d <DIR>      Destination directory"
    echo "  -f <FORMAT>   Output format (default: $OUT_FORMAT)"
    exit 0
    ;;
  esac
done

shift $(($OPTIND-1))

OUT_OPTS="${OUT_FORMAT^^}_OPTS"
for IN in "$@"; do
  OUT="$OUT_DIR/${IN%.*}.$OUT_FORMAT"
  (set -x; ffmpeg -hide_banner -i "$IN" ${!OUT_OPTS} "$OUT")
done
