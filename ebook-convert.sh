#!/bin/bash
if [ $# -lt 1 ] ; then
  echo "$0 <file>"
  exit 1
fi

TOOL="$HOME/tools/calibre/ebook-convert"
INPUT_FILE="$1"
OUTPUT_FILE=
OPTIONS=

kindlesettings() {
  FORMAT="mobi"
  FILE_NAME=`basename "$INPUT_FILE"`
  OUTPUT_FILE="${FILE_NAME%.*}.$FORMAT"
#  OPTIONS="--enable-heuristics --remove-paragraph-spacing"
  OPTIONS="--output-profile=kindle"
}

settings() {
  echo "Output: $OUTPUT_FILE"
  echo "Options: $OPTIONS"
}

kindlesettings

settings

"$TOOL" "$INPUT_FILE" "$OUTPUT_FILE" $OPTIONS
