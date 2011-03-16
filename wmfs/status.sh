#!/bin/sh
#WMFS status.sh
#Will be executed if put in ~/.config/wmfs/
#Timing adjustable in wmfsrc (misc -> status_timing)

prmem()
{
  grep -m 1 -e "Active:" /proc/meminfo | awk '{ printf "%dM",$2/1024 }'
}

prtime()
{
  date '+%a %F %H:%M'
}

prbatt()
{
  BATT="/sys/class/power_supply/BAT0/"
  STAT=`cat ${BATT}/present`
  if [ -e "$STAT" -o "$STAT" -ne 1 ]; then
    echo "--+"
    return
  fi
  STAT=`cat ${BATT}/status`
  if [ "$STAT" = "Full" ]; then
    echo "##"
    return
  fi
  if [ "$STAT" = "Charging" ]; then
    STAT="+"
  else
    STAT="-"
  fi
  CAP=`cat ${BATT}/energy_full`
  CUR=`cat ${BATT}/energy_now`
  CUR=$(($CUR * 100 / $CAP))
  echo "${CUR}${STAT}"
}

wmfs -s "`prmem`|`prbatt`|`prtime`"
