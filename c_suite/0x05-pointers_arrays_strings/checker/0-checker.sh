#!/bin/bash
# This script checks if the output of the main file is as expected
func_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/checker_functions.sh
# func_dir="$(dirname "$0")"/checker_functions.sh
if [ -f "$func_dir" ]; then
	source "$func_dir"
else
	source checker_functions.sh
fi


setup_colors
task_file="0-reset_to_98.c"
setup_c "$task_file"
echo -e "---------------------------------${BLU}Checking $(basename "$source_file")...${WHT}---------------------------------"
execute
clean_up
echo -e "--------------------------------------------------------------------------------------"
#exit 0
