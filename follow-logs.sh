#!/bin/bash
LOGFILE=$1
shift
SERVERS=$@

if [ -z "$LOGFILE" ] || [ -z "$SERVERS" ]; then
	echo $0 "<LOGFILE> <SERVER>..."
	exit 1
fi

COUNT=0
tmux new-window -n "$LOGFILE"

for SERVER in $SERVERS; do
	CMD="ssh $SERVER tail -F $LOGFILE"

	if [[ $COUNT -eq 0 ]]; then
		tmux send-keys "$CMD" C-m
	else
		tmux split-window "$CMD" \; select-layout tiled
	fi
	COUNT=$((COUNT + 1))
done

tmux set-window-option -t "$LOGFILE" synchronize-panes on
