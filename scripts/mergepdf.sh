#!/bin/sh

if [ $# -lt 2 ]; then
	echo "$0 <output.pdf> <inputX.pdf>..."
	exit 1
fi

OUT=$1;
shift

if [ -f "$OUT" ]; then
	echo "$OUT already existed."
	exit 1
fi

TMP1=`mktemp`
TMPX=`mktemp`
touch "$TMPX"

while [ "$1" ]; do
	echo "Converting: $1"
	pdf2ps "$1" "$TMP1"
	if [ $? -ne 0 ]; then
		echo "Error."
		exit 1
	fi

	cat "$TMP1" >> "$TMPX"
	shift
done

echo "Merging: $OUT"
ps2pdf "$TMPX" "$OUT"

rm "$TMP1" "$TMPX"
