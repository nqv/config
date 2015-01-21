#!/bin/sh
# See http://ghostscript.com/doc/current/Ps2pdf.htm
if [ $# -lt 1 ]; then
	echo "$0 <OUTPUT_FILE> <INPUT_FILES...>"
	exit 1
fi
OUTPUT_FILE="$1"
PAPER_SIZE="a4"
# /screen low-resolution
# /ebook medium-resolution
# /printer Print Optimized
# /prepress Prepress Optimized
# /default a wide variety of uses
#PDF_SETTINGS="\
#  -dPDFSETTINGS=/prepress \
#  "
PDF_SETTINGS="\
  -dPDFSETTINGS=/screen \
  -dColorImageDownsampleType=/Bicubic \
  -dColorImageResolution=150 \
  "

shift 1

gs -sDEVICE=pdfwrite -sPAPERSIZE="$PAPERSIZE" \
	-dNOPAUSE -dBATCH -dSAFER \
        $PDF_SETTINGS \
	-sOutputFile="$OUTPUT_FILE" \
	"$@"
