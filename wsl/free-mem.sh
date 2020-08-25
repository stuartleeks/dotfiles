#!/bin/bash

FREE_ARGS="-k"

if [[ $(free --help  2>&1 | grep -q human; echo $?) == 0 ]]; then
    FREE_ARGS="-h"
fi

echo $FREE_ARGS | xargs free

sync
echo 3 > /proc/sys/vm/drop_caches

echo $FREE_ARGS | xargs free
