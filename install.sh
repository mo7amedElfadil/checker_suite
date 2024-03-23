#!/usr/bin/env bash

FILE="$HOME/bin/checker"
echo "Installing..."
touch "$FILE" && chmod u+x "$FILE"
cp checker.sh "$FILE"
sleep 1
echo "Done"
