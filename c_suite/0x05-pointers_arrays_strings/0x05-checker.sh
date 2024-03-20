#!/usr/bin/env bash
checker_dir="checker"

for file in $(find ./$checker_dir -type f -name "*.sh"); do
	if [ -x "$file" ]; then
		echo "Running $file"
		./"$file"
	fi
done
