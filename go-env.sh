#!/bin/bash
export GOPATH=$(dirname -- "$(readlink -f -- "$BASH_SOURCE[0]")")
if [ -z "$1" ]; then
	export GOROOT="$HOME/tools/go"
else
	export GOROOT="$1"
fi
for P in "$GOPATH" "$GOROOT"; do
	GOBIN="$P/bin"
	if [[ ":$PATH:" != *":$GOBIN:"* ]]; then
		export PATH="$GOBIN:$PATH"
	fi
done
echo "GOROOT:" "$GOROOT"
echo "GOPATH:" "$GOPATH"
echo "PATH:  " "$PATH"
