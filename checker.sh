#!/usr/bin/env bash

DIR_PATH="$(find ~ -name "checker_suite" -type d)"
RED='\e[0;31m'
BRN='\e[1;33m'
GRN='\e[0;32m'
BLU='\e[0;34m'
ORNG='\e[38;5;208m'
CYAN='\e[0;36m'
WHT='\e[0m'

help_()
{
cat <<- _EOF_
		Usage: checker [-l language] [-p project] [-t task]
		Options:
		  -h help     : this help
		  -l language : language to run the checker against
		  -p project  : the project to run the checker for
		  -t task     : task number
		  -a all      : run all tasks for every language
		Or:
		  You can use the script w/out flags, then u'll be prompted to select for various options
		Example:
		  checker -l c -p 0x00 -t 1
		  will run task '1' in project '0x00' of the language 'c'
		  checker -l c -p 0x00 -t *
		  will run all the tasks in project '0x00' of the language 'c'
_EOF_
exit
}


err()
{
	local msg="$1"
	echo -e "${RED}$msg${WHT}" && exit 1
}


task()
{
	local proj="$1"
	local errno=1
	local task="*.sh"

	# if task option arg provided; then globe it
	if [ -n "$TASK" ]; then
		# check for file extension
		[[ -n "$TASK" && ! "$TASK" =~ \.sh$ ]] && task="$TASK*.sh" || task="$TASK"
	fi

	#echo "la: $LA, project: $PROJECT, proj: $proj"

	# if no project arg and there's a task flag; then exit
	[[ -z "$PROJECT" && -n "$TASK" ]] && echo "Usage: no project" >&2 && exit 1

	while read file; do
		[ -x "$file" ] && source "$file" && errno=0
	done <<< "$(find "$proj/checker" -name "$task" 2> /dev/null)"

	[ "$errno" -ne 0 ] && err "No task found in $proj"
}

project()
{
	local suite="$1"
	local all="$2"
	local errno=1
	local proj="0x*"

	# if porject option arg provided; then globe it
	[ -n "$PROJECT" ] && proj="$PROJECT*"

	# if no project arg and there's a language; then exit
	[[ -n "$LA" && -z "$PROJECT" ]] && err "No project for the Language <$LA>"

	# No langauge and no all flag
	[ -z "$all" ] && [[ -z "$LA"  ]] && err 'No language provided'

	#echo "PROJECT: $PROJECT, proj: $proj"

	while read -r dir; do
		# perform pattern match w/ regex
		# Don't qoute the right side, or regex matching pattern will not work
		if [[ -d "$dir" && $(basename "$dir") =~ ^0x.* ]]; then
			errno=0
			task $dir
		fi
	done <<< $(find "$suite" -name "$proj" -type d 2> /dev/null)

	[ "$errno" -ne 0 ] && err "No project found in $suite"
}

all()
{
	# Looping thro the suites
	local ROOT_DIR="$1"

	for dir in $ROOT_DIR/*; do
		if [ -d "$dir" ]; then
			project $dir "all"
		fi
	done
}

lang()
{
	case $1 in
		"c") project "$DIR_PATH/c_suite";;
		"py") project "$DIR_PATH/py_suite";;
		*) echo "No language!" ;;
	esac
}

# parse options
while getopts ":at:p:l:h" opt; do
	case $opt in
		a) all "$DIR_PATH"; break;;
		t) TASK="$OPTARG";;
		p) PROJECT="$OPTARG";;
		l) LA="$OPTARG";;
		# TODO: help or manual
		h) help_;;
		\?) echo "Wrong option"; exit 1;;
		:)
			case "$OPTARG" in
				t) echo -e "${ORNG}No argument provided for -t${WHT}";;
				p) echo -e "${ORNG}No argument provided for -p${WHT}";;
				l) echo -e "${ORNG}No argument provided for -l${WHT}";;
				*) echo -e "${ORNG}No argument provided for $opt${WHT}";;
			esac
			;;
	esac

done

if [ "$OPTIND" -gt 1 ]; then
	# non-interactive mode
	if [[ -n "$TASK"  &&  -z "$PROJECT"  &&  -z "$LA" ]]; then
		# handle executing task when no project path

		PROJECT="$(basename $PWD)"
		LA="$(basename $(dirname $PWD) | cut -d'_' -f1)"
		task "$PWD"
	else
		[ -z "$LA" ] && read -rp "Please provid a language(c/py) :-> " LA
		[ -z "$PROJECT" ] && read -rp "Please provid a project(only the hex) :-> " PROJECT
		[ -z "$TASK" ] && read -rp "Please provid a task(only the number) :-> " TASK
		lang "$LA"
	fi
else
# No option provided, interactive mode

	# declare -A basically syntax for difining associative array in bash
	declare -A suites
	declare -A projs
	declare -A tsks

	echo "Select suite option:"
	i=1
	j=0

	# Looping thro the suites
	for dir in $DIR_PATH/*; do
		if [ -d "$dir" ]; then
			suite=$(basename $dir)
			suites[$i]="$suite"
			echo "$i- $suite" && ((i++))
		fi

	done
	read -r suite

	# select a suite option
	case $suite in
		1)
			LA="c"
			echo -e "Select a project number:"

			#select a project
			for proj in "$DIR_PATH/${suites[1]}"/*; do
				if [ -d "$proj" ]; then
					pro="$(basename $proj)"
					projs[$j]="$pro"
					echo -e "${CYAN}$j-${WHT} ${projs[$j]}" && ((j++))
				fi
			done
			echo -e "${CYAN}$j-${WHT} all"

			read -r proj_opt

			# wrong option selection
			[[ "$proj_opt" > $j || "$proj_opt" < 0 ]] && err "Wrong option <$proj_opt>"

			# all projects in suite
			if [ "$proj_opt" -eq "$j" ]; then
				PROJECT="0x*"
				lang "$LA"
				exit "$?"
			fi

			PROJECT=${projs[$proj_opt]}

			echo -e "Select a task number:"

			#select a task
			j=0
			for tsk in "$DIR_PATH/${suites[1]}/$PROJECT/checker/"[0-9]-*.sh; do
				ts="$(basename $tsk)"
				tsks[$j]="$ts"
				echo -e "${CYAN}$j-${WHT} ${tsks[$j]}" && ((j++))
			done
			echo -e "${CYAN}$j-${WHT} all"

			read -r tsk_opt

			# wrong option selection
			[[ "$tsk_opt" > $j || "$tsk_opt" < 0 ]] && err "Wrong option <$tsk_opt>"

			TASK="${tsks[$tsk_opt]}"
			lang "$LA"

			;;
		2) echo "Python Under development";;
		*) echo "Wrong option"; checker;;
	esac
fi
