#!/bin/sh

if [ $# -eq 0 ] ; then
  echo "$0 [-ker] <file1> <file2> ..."
  exit 1;
fi

RECUR=0
SETID=0
SETEOL=0

svnadd() {
  file=$1
 
  if [ $RECUR -eq 1 ] ; then
    svn add "$file"
  else
    svn add --depth empty "$file"
  fi
  if [ -d "$file" ] ; then
    return
  fi
  if [ $SETID -eq 1 ] ; then
    svn propset svn:keywords Id "$file"
  fi
  if [ $SETEOL -eq 1 ] ; then
    svn propset svn:eol-style native "$file"
  fi
}

# main

while getopts "ker:" flag
do
  case $flag in
  k)
    SETID=1
    ;;
  e)
    SETEOL=1
    ;;
  r)
    RECUR=1
    ;;
  :)
    echo "$OPTARG"
    ;;
  \?)
    exit 1
    ;;
  esac
done

shift $(($OPTIND -1))
for i in "$@"; do
  svnadd "$i"
done
