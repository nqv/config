#!/bin/sh
if [ $# -lt 1 ]; then
	echo "$0 <OUTPUT_FILE> <INPUT_FILES...>"
	exit 1
fi
OUTPUT_FILE="$1"
PAPER_SIZE=a4

shift 1

gs -sDEVICE=pdfwrite -sPAPERSIZE="$PAPERSIZE"\
	-dNOPAUSE -dBATCH -dSAFER -dPDFSETTINGS=/prepress \
	-sOutputFile="$OUTPUT_FILE" \
	"$@"
