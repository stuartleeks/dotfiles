#!/bin/bash
set -e

# This script is used to extract the characters at specified positions from a given string.
# The string to extract characters from is piped into the script.
# The script takes a list of positions as arguments and prints the characters at those positions.
# e.g. "echo 'hello world' | get-chars.sh 1 3 5"
# Note that the positions are 1-based, meaning that the first character is at position 1.


# get the string from stdin
string=$(cat -)
# check if the string is empty
if [[ -z "$string" ]]; then
	echo "Error: No string provided."
	exit 1
fi

# check if any positions were provided
positions=("$@")
if [[ $# -eq 0 ]]; then
	echo "Error: No positions provided."
	exit 1
fi


# extract the characters at the specified positions
for pos in "${positions[@]}"; do
	echo -n "${string:$pos-1:1} "
done
echo