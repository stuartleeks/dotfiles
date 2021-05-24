#!/bin/bash

#
# Usage:
#   save-args.sh <filename> arg1 arg2 ...
#
# save-args will write arg1, arg2, ... to <filename> (one arg per line)
#

filename=$1

if [[ -z "$1" ]]; then
  echo "Need a minimum of one argument specifying the output filename"
  exit 1
fi

if [[ -f "$filename" ]]; then
  rm "$filename"
fi

touch "$filename"
for i in "${@:2}"; do
  echo "$i" >> "$filename"
done
