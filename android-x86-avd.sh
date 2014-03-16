#!/bin/sh
SDK=~/tools/android-sdk-linux
AVD="$1"

if [ -z "$AVD" ]; then
  echo "$0 <AVD>"
  exit 1
fi

# Missing libGL.so
if [ ! -f "$SDK/tools/lib/libGL.so" ]; then
  ln -s "/usr/lib/i386-linux-gnu/libGL.so.1.2.0" "$SDK/tools/lib/libGL.so"
fi

shift 1
LD_LIBRARY_PATH="$SDK/tools/lib" "$SDK/tools/emulator-x86" -avd "$AVD" \
  -no-boot-anim \
  -no-audio \
  "$@" \
  -qemu -m 2047 -enable-kvm
