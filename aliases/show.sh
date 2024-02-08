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

file_or_dir="$1"

if [[ "$file_or_dir" == "-h" || "$file_or_dir" == "--help" ]]; then
	show_usage
	exit 0
fi

if [[ -z "$file_or_dir" ]]; then
	file_or_dir="."
fi

if [[ -d "$file_or_dir" ]]; then
	ls -alh --color=always "$file_or_dir"
else
	if [[ $(command -v batcat > /dev/null; echo $?) == 0 ]]; then
		batcat "$file_or_dir"
	else
		cat "$file_or_dir"
	fi
fi

