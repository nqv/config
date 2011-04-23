#!/bin/bash

if [ $# -lt 1 ]; then
  echo "$0 <DEST>"
  exit 1
fi

rdir=$1
mpoint="/mnt/union"

# Mount a source directory or fs type $i in destination mount point $j 
# using options $k
#
#     i               j                  k
mdirs=( 
  "unionfs"   "$mpoint"         "-t aufs -o dirs=$rdir:/=ro"
  "/dev"      "$mpoint/dev"     "--bind"
  "devpts"    "$mpoint/dev/pts" "-t devpts"
  "shm"       "$mpoint/dev/shm" "-t tmpfs"
  "sysfs"     "$mpoint/sys"     "-t sysfs"
  "proc"      "$mpoint/proc"    "-t proc"
  "/tmp"      "$mpoint/tmp"     "--bind"
)
 
mount_unionfs() {
  mdir_size=${#mdirs[*]}
 
  i=0; j=1; k=2
  while [ "$i" -lt "$mdir_size" ]; do
    if [ -z "$(mount | grep -w ${mdirs[$j]})" ]; then
      echo "Mounting ${mdirs[$j]}"
      sudo /bin/mount ${mdirs[$k]} ${mdirs[$i]} ${mdirs[$j]}
      if [ $? -ne 0 ]; then 
	echo "mount ${mdirs[$i]} error"
        exit 2
      fi
    fi
    i=$((i + 3)); j=$((j + 3)); k=$((k + 3))
  done
}
 
umount_unionfs() {
  mdir_size=${#mdirs[*]}
 
  j=$((mdir_size - 2))
  while [ "$j" -gt "0" ]; do
    if [ -n "$(mount | grep -w ${mdirs[$j]})" ]; then
      echo "Umounting ${mdirs[$j]}"
      sudo /bin/umount ${mdirs[$j]} 2> /dev/null
    fi
    j=$((j - 3))
  done
}
 
mount_unionfs
 
sudo /usr/sbin/chroot $mpoint /bin/su --shell /bin/bash --login $USER
 
umount_unionfs
