#!/bin/bash

#
# This script sets DEV_CONTAINER=1 and then calls install.sh
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export DEV_CONTAINER=1

$DIR/install.sh