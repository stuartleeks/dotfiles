#!/bin/bash
set -e

function show_usage() {
	script_name=$(basename -- "$0")
    echo
    echo "$script_name file_or_dir"
    echo
    echo "List files in a directory or display a file"
    echo
}

if [[ -z $1 ]]; then
	show_usage
	exit 1
fi

if [[ -d $1 ]]; then
	ls -al --color=always $1
else
	if [[ $(command -v batcat > /dev/null; echo $?) == 0 ]]; then
		batcat $1
	else
		cat $1
	fi
fi

