#!/usr/bin/env bash
# this runs all the checker scripts
checker_dir="checker"

for file in $(find $checker_dir -type f -name "*.sh"); do
	if [ -x "$file" ]; then
		echo "Running $file"
		./"$file"
	fi
done
