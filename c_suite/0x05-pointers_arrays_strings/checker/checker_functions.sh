#!/bin/bash
function setup_colors() {
	RED='\e[0;31m'
	BRN='\e[1;33m'  
	GRN='\e[0;32m'
	BLU='\e[0;34m'
	WHT='\e[0m'
}

function setup_c() {
	task_file="$1"
	base_dir="$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"
	source_file="$base_dir/$task_file"
	if [ ! -f "$source_file" ]; then
		source_file="../$task_file"
		if [ ! -f "$source_file" ]; then
			echo "File not found: $source_file"
			exit 1
		fi
	fi
	pr=$(basename "$source_file" | cut -d'-' -f1)

	main_file="$base_dir/main_files/$pr-main.c"
	if [ ! -f "$main_file" ]; then
		main_file="../main_files/$pr-main.c"
		if [ ! -f "$main_file" ]; then
			main_file=""
		fi
	fi
	executable_file="$pr-executable"
	expected_output_file="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/output/$pr-expected_output.txt"
	error_file="$pr-error.txt"
}

# test code style
function test_style() {
	for i in "$@"; do
		extension=$(echo "$i" | rev | cut -d'.' -f1 | rev)
		if [[ $extension == "py" ]]; then
			tester=pycodestyle
		elif [[ $extension == "js" ]]; then
			tester=semistandard
		elif [[ $extension == "sh" ]]; then
			tester=shellcheck
		elif [[ $extension == "c" ]]; then
			tester=betty
		fi
		if [ -z "$tester" ]; then
			echo -e "${RED}No code style checker found for $extension files. Please Install it.${WHT}"
			continue
		fi
		if $tester "$i" 2> /dev/null; then
			echo -e "${GRN}Code style OK.${WHT}"
		else
			echo -e "${RED}Code style not OK.${WHT}"
		fi
	done
}

# Print the error file in red
function print_err() {
	RED='\e[1;33m'   
	WHT='\033[0m'        

	local filename="$1"

	if [ ! -f "$filename" ]; then
		echo "File not found: $filename"
		return 1
	fi

	sed "s/.*/$(printf "${RED}&${WHT}")/" "$filename"
}

function clean_up() {
	if [ -f "$error_file" ]; then
		rm "$error_file"
	fi
	if [ -f "$executable_file" ]; then
		rm "$executable_file"
	fi
}

function execute() {
	if ! gcc -Wall -pedantic -Werror -Wextra -std=gnu89 "$main_file" "$source_file" -o "$executable_file" 2> "$error_file"; then
		echo -e "${RED}Compilation failed.${WHT}"
		if [ -s "$error_file" ]; then
			echo -e "${RED}Error(s) detected:${WHT}"
			print_err "$error_file"
		fi
		return 1
	fi

	output=$(./"$executable_file" "${@:2}")
	if [ $? -eq 139 ]; then
		echo -e "${RED}Segmentation fault occurred.${WHT}"
		return 1
	fi

	expected_output=$(< "$expected_output_file")

	if [ "$output" = "$expected_output" ]; then
		echo -e "${GRN}Output matches expected output.${WHT}"
		echo -e "${BLU}OK${WHT}"
		test_style "$source_file"
	else
		echo -e "${RED}Output does not match expected output.${WHT}"
		echo -e "${BRN}Expected output:\n${WHT}"
		cat "$expected_output_file"
		echo -e "${BRN}Your output:\n${WHT}"
		echo "$output"
	fi
	return 0
}
