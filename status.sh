#!/bin/bash

CPU=""
CPUIDLE=0
CPUTOTAL=0
cpu() {
	# cpu 2:user 3:nice 4:system 5:idle 6:iowait 7:irq 8:softirq 9:steal 10:guest 11:guest_nice
	read CPUIDLE CPUTOTAL CPU < <(grep 'cpu ' /proc/stat | awk -v pidle="$CPUIDLE" -v ptotal="$CPUTOTAL" '{idle=$5+$6; total=$2+$3+$4+$5+$6+$7+$8+$9+$10+$11; if (ptotal>0) {percent=int(100*(total-ptotal-idle+pidle)/(total-ptotal))} else {percent=0}; print idle,total,percent}')
}

MEMORY=""
memory() {
	MEMORY="$(free | grep 'Mem:' | awk '{print int($3*100/$2)}')"
}

BATTERY=""
BATTERYPATH="/sys/class/power_supply/BAT0"
battery() {
	BATTERY="--"
	PRESENT="$BATTERYPATH/present"
	STATUS="$BATTERYPATH/status"
	if [ ! -f "$PRESENT" ] || [ ! -f "$STATUS" ]; then
		return
	fi
	PRESENT="$(cat "$PRESENT")"
	if [ "$PRESENT" != "1" ]; then
		return
	fi
	STATUS="$(cat "$STATUS")"
	case "$STATUS" in
		Full)
			BATTERY="100"
			return
			;;
		Charging)
			STATUS="+"
			;;
		Discharging)
			STATUS="-"
			;;
	esac
	CAPACITY="$(cat "$BATTERYPATH/capacity")"
	BATTERY="$CAPACITY$STATUS"
}

SYSTIME="-"
systime() {
	SYSTIME="$(date '+%a %F %R')"
}

while :; do
	cpu
	memory
	battery
	systime
	echo "C$CPU M$MEMORY B$BATTERY" "$SYSTIME"
	sleep 10
done
