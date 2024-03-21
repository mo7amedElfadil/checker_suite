#!/usr/bin/env bash

FILE="$HOME/bin/checker"
if [ ! -x "$FILE" ]; then
	echo "Installing..."
	touch "$FILE" && chmod u+x "$FILE"
	cp checker "$FILE"
	sleep 1
	echo "Done"
fi
