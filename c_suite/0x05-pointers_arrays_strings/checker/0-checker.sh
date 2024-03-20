#!/bin/bash
# This script checks if the output of the main file is as expected
source "$(dirname "$0")"/checker_functions.sh

setup_colors
task_file="0-reset_to_98.c"
setup_c "$task_file"
echo -e "----------------${BLU}Checking $(basename "$source_file")...${WHT}--------------------"
execute
clean_up
echo -e "------------------------------------"
exit 0
