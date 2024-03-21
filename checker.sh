#!/usr/bin/env bash

DIR_PATH="$(find ~ -name "checker_suite" -type d)"

task()
{
	local dir="$1"

	# if task option arg provided; then globe it
	[ -n $TASK ] && task="$TASK*.sh" || task="[0-9]-*.sh"

	# if no project arg; then exit
	# [ -z $PROJECT ] && echo "Usage: no project" >&2 && exit 1

	while read file; do
		source "$file"
	done <<< "$(find $dir -name "$task")"
}

project()
{
	local suite="$1"
	local all="$2"

	# if porject option arg provided; then globe it
	[ -n "$PROJECT" ] && proj="$PROJECT*" || proj="*"

	# if no project arg; then exit
	# [ -z "$PROJECT" ] && echo "Usage: no project" >&2 && exit 1

	[ -z "$all" ] && [ -z "$LA" ] && echo 'No language provided' && exit 1

	while read dir; do
		if [ -d "$dir" ]; then
			task $dir
		fi
	done <<< $(find "$suite"/$proj -name "checker" -type d)
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
		*) echo "Invalid" ;;
	esac
}

# parse options
while getopts ":at:p:l:" opt; do
	case $opt in
		a) all "$DIR_PATH"; break;;
		t) TASK="$OPTARG";;
		p) PROJECT="$OPTARG";;
		l) LA="$OPTARG";;
		h) echo 'this is help'; exit;;
		\?) echo "Wrong option";;
		:) echo "no optoion provided";;
	esac

done

# No option provided
if [ "$OPTIND" -gt 1 ]; then
	lang "$LA"
else
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
			echo -e "Select a project:"

			#select a project
			for proj in "$DIR_PATH/${suites[1]}"/*; do
				if [ -d "$proj" ]; then
					pro="$(basename $proj)"
					projs[$j]="$pro"
					echo -e "$j- ${projs[$j]}" && ((j++))
				fi
			done
			read -r proj_opt
			PROJECT=${projs[$proj_opt]}

			echo -e "Select a task:"

			#select a task
			j=1
			for tsk in "$DIR_PATH/${suites[1]}/$PROJECT/checker"/[0-9]-*.sh; do
				ts="$(basename $tsk)"
				tsks[$j]="$ts"
				echo -e "$j- ${tsks[$j]}" && ((j++))
			done

			read -r tsk_opt
			source "$DIR_PATH/${suites[1]}/$PROJECT/checker/${tsks[$tsk_opt]}"

			;;
		2) project "$DIR_PATH/${suites[2]}";;
		*) echo Wrong option; checker;;
	esac
fi
