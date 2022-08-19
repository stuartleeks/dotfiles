#!/bin/bash

#
# This script sets DEV_CONTAINER=1 and then calls install.sh
#

echo -e "\033[0;93m========================== dotfiles install - start ==========================\033[0m"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export DEV_CONTAINER=1

$DIR/install.sh

echo -e "\033[0;93m========================== dotfiles install - end   ==========================\033[0m"