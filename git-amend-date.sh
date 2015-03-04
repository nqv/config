#!/bin/sh
if [ -z "$1" ]; then
	echo "Usage: $0 \"$(date -R)\""
  exit 1;
fi
GIT_COMMITTER_DATE="$1" git commit -v --amend --date="$1"
