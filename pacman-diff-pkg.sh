#!/bin/bash
ver=$(pacman -Q "$1" | cut -f2 -d' ')
pacman -Qkkq "$1" | while read package file
do
  echo "$file"
  bsdtar -xOf "/var/cache/pacman/pkg/${package}-${ver}-$(uname -m).pkg.tar.xz" "${file/\//}" | diff -uN - "$file"
done
