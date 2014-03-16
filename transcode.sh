#!/bin/sh
# lame, libid3-tools
MFILE=audiodump.wav
SCRIPT="$0"
OUT_DIR=.
OUT_FORMAT=mp3

MP3_ARG="-h -V 5"
OGG_ARG="-q 4"

# LAME V 3 - 175 kbps
#      V 5 - 130
to_mp3() {
  lame $MP3_ARG "$1" "$2"
}

# Vorbis q 6 - 192 kbps
#          4 - 128
to_ogg() {
  oggenc $OGG_ARG -o "$2" "$1"
}

# output audiodump.wav
to_wav() {
  mplayer -vo null -vc dummy -af resample=44100 -ao pcm:waveheader "$1"
}

mp3_mp3() {
  to_mp3 "$1" "$2"
  id3cp "$1" "$2"
}

any_mp3() {
  to_wav "$1" && to_mp3 "$MFILE" "$2"
  rm "$MFILE"
}

any_ogg() {
  to_wav "$1" && to_ogg "$MFILE" "$2"
  rm "$MFILE"
}

usage() {
  echo "Usage: $SCRIPT [OPTION] [DIR]"
  echo "  -o <mp3|ogg>  Output format"
  echo "  -d <DIR>      Destination directory"
}

###

while getopts "o:d:h" flag; do
  case $flag in
  o)
    OUT_FORMAT="$OPTARG"
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

while [ "$1" ]; do
  if [ -f "$1" ]; then
    # Detect file format
    IN_DIR=`dirname "$1"`
    IN_FILE=`basename "$1"`
    IN_FORMAT=${IN_FILE##*.}

    CONV_CMD="${IN_FORMAT}_${OUT_FORMAT}"
    if ! type "$CONV_CMD" > /dev/null ; then
      echo "Using mplayer to transcode."
      CONV_CMD="any_${OUT_FORMAT}"
      if ! type "$CONV_CMD" > /dev/null ; then
        echo "$IN_FORMAT to $OUT_FORMAT is not supported."
	exit 2
      fi
    fi
    OUT_FILE="$OUT_DIR/${IN_FILE%.*}.$OUT_FORMAT"

    echo ">>> Convert $1 to $OUT_FILE"
    if [ -f "$OUT_FILE" ]; then
      echo "File already existed"
      exit 1
    fi
    $CONV_CMD "$1" "$OUT_FILE"
  fi
  shift
done
