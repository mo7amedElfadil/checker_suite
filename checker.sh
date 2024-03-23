#!/usr/bin/env bash

DIR_PATH="$(find ~ -name "checker_suite" -type d)"

# ===========TODO==========:
# 1- help or manual
# 2- if there's no project, there should prompt for it
# 3- if there's no langauge, there should prompt for it
# 4- if there's no task, there should prompt for it 
# 5- the order of the flags
# 6- checker -t, should look in pwd, wt if I have task 0x01 for each language ?

# =========BUGS==========:
# 1- wrong optoin provided(don't trust the user) <DONE>

function setup_colors() {
	RED='\e[0;31m'
	BRN='\e[1;33m'
	GRN='\e[0;32m'
	BLU='\e[0;34m'
	WHT='\e[0m'
}
# colors init
setup_colors

task()
{
	local dir="$1"

	# if task option arg provided; then globe it
	if [[ -n "$TASK" ]]; then
		[[ $(echo $TASK | rev | cut -d'.' -f1 | rev) != 'sh' ]] && task="$TASK*.sh" || task="$TASK"
	else
		task="*.sh"
	fi

	# if no project arg and there's a task flag; then exit
	[[ -z $PROJECT && -n $TASK ]] && echo "Usage: no project" >&2 && exit 1

	while read file; do
		[ -x "$file" ] && source "$file"
	done <<< "$(find "$dir/checker" -name "$task" 2> /dev/null)"

	errno=$?
	if ((errno != 0)); then
		echo -e "${RED}You need to be in the project directory!${WHT}"
	fi
}

project()
{
	local suite="$1"
	local all="$2"

	# if porject option arg provided; then globe it
	[ -n "$PROJECT" ] && proj="$PROJECT*" || proj="*"

	# if no project arg and there's a language; then exit
	[[ -n "$LA" && -z "$PROJECT" && -d $LA*/$proj ]] && echo "No project for the Language <$LA>" && exit

	# No langauge and no all flag
	[ -z "$all" ] && [[ -z "$LA"  ]] && echo 'No language provided' && exit 1

	while read dir; do
		if [ -d "$dir" ]; then
			task $dir
		fi
	done <<< $(find "$suite"/$proj -name "0x*" -type d)
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
		*) echo "No lnaguage!" ;;
	esac
}

# parse options
while getopts ":at:p:l:" opt; do
	case $opt in
		a) all "$DIR_PATH"; break;;
		t) TASK="$OPTARG";;
		p) PROJECT="$OPTARG";;
		l) LA="$OPTARG";;
		# TODO: help or manual
		h) echo 'this is help'; exit;;
		\?) echo "Wrong option";;
		:) echo "no optoion provided";;
	esac

done

if [ "$OPTIND" -gt 1 ]; then
	if [ -n $TASK ] && [ -z $PROJECT ] && [ -z $LA ];then
		PROJECT=$(dirname "$(pwd)")
		task `pwd`
	fi
	lang "$LA"
else
# No option provided

	# declare -A basically syntax for difining associative array in bash
	declare -A suites
	declare -A projs
	declare -A tsks

	echo "Select suite option:"
	i=1
	j=1

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
					echo -e "$j- ${projs[$j]}" && ((j++))
				fi
			done
			echo -e "$j- all"

			read -r proj_opt
			# wrong option selection
			[[ $proj_opt > $j || "$proj_opt" < 1 ]] && echo -e "${RED}Wrong option${WHT} <$proj_opt>" && exit 1

			# all project in suite
			[ "$proj_opt" == "$j" ] && PROJECT="*" && lang "$LA" && exit

			PROJECT=${projs[$proj_opt]}

			echo -e "Select a task number:"

			#select a task
			j=1
			for tsk in "$DIR_PATH/${suites[1]}/$PROJECT/checker"/[0-9]-*.sh; do
				ts="$(basename $tsk)"
				tsks[$j]="$ts"
				echo -e "$j- ${tsks[$j]}" && ((j++))
			done
			echo -e "$j- all"

			read -r tsk_opt
			# wrong option selection
			[[ $tsk_opt > $j || "$tsk_opt" < 1 ]] && echo "${RED}Wrong option <$tsk_opt>${WHT}" && exit 1

			# all tasks in a suite
			[ "$tsk_opt" == "$j" ] && TASK="*" && lang "$LA" && exit

			TASK="${tsks[$tsk_opt]}"
			lang "$LA"

			;;
		2) echo "Python Under development";;
		*) echo Wrong option; checker;;
	esac
fi
