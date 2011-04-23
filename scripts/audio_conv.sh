#!/bin/sh
MFILE=audiodump.wav
SCRIPT="$0"
IN_DIR=.
OUT_DIR=.
IN_EXT=wma
OUT_EXT=mp3

# LAME V 3 - 175 kbps
#      V 5 - 130
to_mp3() {
  lame -h -V 5 "$1" "$2"
}

# Vorbis q 6 - 192 kbps
#          4 - 128
to_ogg() {
  oggenc -q 4 -o "$2" "$1"
}

# output audiodump.wav
from_wma() {
  mplayer -vo null -vc dummy -af resample=44100 -ao pcm:waveheader "$1"
}

wma_mp3() {
  OUT_FILE="${OUT_DIR}/`basename "$1" .wma`.mp3"
  from_wma "$1" && to_mp3 "$MFILE" "$OUT_FILE"
  rm "$MFILE"
}

wma_ogg() {
  OUT_FILE="${OUT_DIR}/`basename "$1" .wma`.ogg"
  from_wma "$1" && to_ogg "$MFILE" "$OUT_FILE"
  rm "$MFILE"
}

mp3_mp3() {
  if [ "$IN_DIR" = "$OUT_DIR" ] ; then
    echo "SRC = DEST"
    exit 2
  fi
  OUT_FILE="${OUT_DIR}/`basename "$1"`"
  to_mp3 "$1" "$OUT_FILE"
  id3cp "$1" "$OUT_FILE"
}

usage() {
  echo "Usage: $SCRIPT [OPTION] [DIR]"
  echo "  -i <mp3|wma>  Input format"
  echo "  -o <mp3|ogg>  Output format"
  echo "  -d <DIR>      Destination directory"
}

###

while getopts "i:o:d:h" flag; do
  case $flag in
  i)
    IN_EXT="$OPTARG"
    ;;
  o)
    OUT_EXT="$OPTARG"
    ;;
  d)
    OUT_DIR="$OPTARG"
    ;;
  h|*)
    usage
    exit 0
    ;;
  esac
done

shift $(($OPTIND-1))
if [ ! -z "$1" ]; then
  IN_DIR="$1"
fi
if [ ! -d "$IN_DIR" ]; then
  echo "Directory not found: $IN_DIR"
  exit 1
fi
if [ ! -d "$OUT_DIR" ]; then
  echo "Directory not found: $OUT_DIR"
  exit 1
fi

CONV_CMD="${IN_EXT}_${OUT_EXT}"
if ! type "$CONV_CMD" > /dev/null ; then
  echo 'Extension not supported'
  exit 2
fi

for i in "$IN_DIR"/*."$IN_EXT" ; do
  echo ">>> Convert $1..."
  $CONV_CMD "$i"
done

