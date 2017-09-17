#!/bin/sh
set -e

# Partition size in blocks and sectors - to be calculated
BLOCKS=
SECTORS=

# TODO
BLOCKSIZE=4096
SECTORSIZE=512
ROUNDSCALE=10000

# resizefs <PARTITION>
# resize partition to its minimum size.
resizefs() {
	e2fsck -f "$1"
	# Get minimum partition size
	OUTPUT="$(resize2fs -P "$1" | grep "Estimated minimum size")"
	echo "$OUTPUT"
	MINSIZE="$(echo "$OUTPUT" | awk -F ': ' '{print $2}')"
	BLOCKS="$(echo "scale=0; ($MINSIZE/$ROUNDSCALE + 1)*$ROUNDSCALE" | bc)"
	echo "Resize filesytem $1 to $BLOCKS."
	echo "Press Enter to continue or ^C to cancel..."
	read _
	resize2fs "$1" "$BLOCKS"
}

# resizepart <DEV> <PARTNO>
resizepart() {
	# Get start sector
	OUTPUT="$(parted "$1" unit s print)"
	echo "$OUTPUT"
	START="$(echo "$OUTPUT" | awk "/^ $2/{gsub(/s$/,\"\",\$2); print \$2}")"
	SECTORS="$(echo "$BLOCKS*$BLOCKSIZE/$SECTORSIZE + $START" | bc)"
	END="$(echo "$SECTORS - 1" | bc)s"
	echo "Resize partition $1 $2 to sector ${END} ($BLOCKS*$BLOCKSIZE/$SECTORSIZE + $START - 1)"
	echo "Press Enter to continue or ^C to cancel..."
	read _
	parted "$1" resizepart "$2" "${END}"
}

# main
if [ "$#" -ne 2 ]; then
	echo $0 "<DEVICE> <PARTNO>"
	exit 1
fi
if [ -f "$1" ]; then
	# Create loop device
	DEV="$(losetup -f)"
	losetup -P "$DEV" "$1"
	resizefs "${DEV}p${2}"
	resizepart "$DEV" "$2"
	losetup -d "$DEV"
	SIZE="$(echo "$SECTORS*$SECTORSIZE" | bc)" 
	echo "Truncate file $1 to size $SIZE ($SECTORS*$SECTORSIZE)".
	echo "Press Enter to continue or ^C to cancel..."
	read _
	truncate -s "$SIZE" $1
elif [ -b "$1" ]; then
	resizefs "$1$2"
	resizepart "$1" "$2"
	SIZE="$(echo "$SECTORS*$SECTORSIZE" | bc)" 
	echo "Minimum size of device:" "$SIZE"
else
	echo "$1" must be a file or block device
	exit 1
fi
