#!/usr/bin/env bash

FILE="$HOME/bin/checker"

echo "Setting up binary.."

[ ! -d "$HOME/bin" ] && mkdir -p "$HOME/bin"

# Set Internal Field Separator to colon
IFS=:

# NOTE: don't qoute $PATH, or splitting won't work
for path in $PATH; do
	[ "$path" == "$HOME/bin" ] && ispresent=1 && break;
done

# Add binary to environment path
[ "$ispresent" != 1 ] && export PATH="$PATH:$HOME/bin"

echo "Installing..."
touch "$FILE" && chmod u+x "$FILE"
cp checker.sh "$FILE"
sleep 1
echo "Done"
