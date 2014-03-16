#!/bin/sh
help() {
  echo "$0 <INPUT> [OPTIONS] <OUTPUT>"
  echo "Options:"
  echo "    -h <num>"
  echo "    -v <num>"
  echo "    -r <num%>"
}

IN=$1
OUT=$2

if [ -z "$IN" -o -z "$OUT" ]; then
  help
  exit 1
fi

# Get inage dimension
D=`gm identify "$IN" | cut -d ' ' -f 3 |\
  awk -F '(x|+)' '{print $1, $2}'`

if [ $? -ne 0 ]; then
  help
  exit 1
fi

W=`echo "$D" | cut -d ' ' -f 1`
H=`echo "$D" | cut -d ' ' -f 2`

echo "$1: $W x $H"

ARGS=""

vsplit1() {
  ARGS="$ARGS -crop 50%x100%+0+0"
}

vsplit2() {
  HALF=$(($W / 2))
  ARGS="$ARGS -crop 50%x100%+$HALF+0"
}

hsplit1() {
  ARGS="$ARGS -crop 100%x50%+0+0"
}

hsplit2() {
  HALF=$(($H / 2))
  ARGS="$ARGS -crop 50%x100%+0+$HALF"
}

shift 2
while getopts 'h:v:r:' ARG; do
  case "$ARG" in
  h)
    if [ "$OPTARG" -eq 1 ]; then
      hsplit1
    else
      hsplit2
    fi
    ;;
  v)
    if [ "$OPTARG" -eq 1 ]; then
      vsplit1
    else
      vsplit2
    fi
    ;;
  r)
    ARGS="$ARGS -resize $OPTARG"
    ;;
  esac
done

echo $ARGS

gm convert "$IN" $ARGS "$OUT"
