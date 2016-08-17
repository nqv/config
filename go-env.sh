#!/bin/bash
GOPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -z "$1" ]; then
	GOROOT="$GOPATH/current"
else
	GOROOT="$1"
fi
if [ ! -d "$GOROOT" ]; then
	echo "GOROOT not found: $GOROOT"
	return
fi

for P in "$GOPATH" "$GOROOT"; do
	GOBIN="$P/bin"
	if [[ ":$PATH:" != *":$GOBIN:"* ]]; then
		PATH="$GOBIN:$PATH"
	fi
done

export GOPATH="$GOPATH"
export GOROOT="$GOROOT"
export PATH="$PATH"

echo "GOROOT:" "$GOROOT"
echo "GOPATH:" "$GOPATH"
echo "PATH:  " "$PATH"
