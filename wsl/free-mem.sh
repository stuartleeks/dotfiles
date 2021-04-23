#!/bin/bash
set -e

# Determine whether the version of `free` supports -h
free_args="-k"
if [[ $(free --help  2>&1 | grep -q human; echo $?) == 0 ]]; then
    free_args="-h"
fi

echo "Memory before:"
echo $free_args | xargs free

echo -e "\nDropping caches../"
sync
echo 1 > /proc/sys/vm/drop_caches

echo -e "\nMemory after:"
echo $free_args | xargs free
