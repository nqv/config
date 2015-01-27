#!/bin/bash
SCRIPTDIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE[0]")")
export GOROOT=~/tools/go
export GOPATH=$SCRIPTDIR
GOBIN=$GOROOT/bin
if [ "$PATH" = "${PATH%$GOBIN*}" ]; then
  export PATH=$PATH:$GOBIN
fi
echo "GOROOT:" "$GOROOT"
echo "GOPATH:" "$GOPATH"
echo "PATH:  " "$PATH"
