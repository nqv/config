#!/bin/sh
pkg="$(pacman -Qo "$1" | awk '//{printf "%s-%s", $(NF-1), $NF;}')" 
bsdtar -xOf "/var/cache/pacman/pkg/${pkg}-$(uname -m).pkg.tar.xz" "${1/\//}" | diff -uN - "$1"
