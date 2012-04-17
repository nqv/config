#!/bin/sh

while [ "$1" ] ; do
	if [ -f "$1" ]; then
		dir=`dirname "$1"`
		name=`basename "$1" | awk '{gsub(/[ ,:]/, "_", $0);gsub(/_+/, "_", $0);print(tolower($0));}'`
		if [ ! -z "$name" ]; then
			echo "$1 -> $dir/$name"
			mv -i "$1" "$dir/$name"
		fi
	fi
	shift
done
