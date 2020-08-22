#!/bin/bash

#
# This script installs dependencies
# It is intended to be run to set up the dotfiles
# And adds to .bashrc to source the load.sh script 
#

BASE_DIR=$(dirname "$0")
BASE_DIR=$(cd $BASE_DIR; pwd)

bash "$BASE_DIR/bash-completion/install.sh"

bash "$BASE_DIR/bash-git-prompt/install.sh"

# TODO - mostly want to set git-aliases in codespaces
# Don't want to set on install as it breaks gitconfig integration in devcontainers
# bash "$BASE_DIR/git-aliases.sh"

if [[ $(grep -q DOTFILES_FOLDER ~/.bashrc; echo $?) == 0 ]]; then
    echo "dotfiles loader already in .bashrc - skipping"
else
    echo "Adding dotfiles loader to .bashrc..."
    echo -e "# DOTFILES_START" >> ~/.bashrc
    echo -e "DOTFILES_FOLDER=\"$BASE_DIR\"" >> ~/.bashrc
    echo -e "source \"$BASE_DIR/load.sh\"" >> ~/.bashrc
    echo -e "# DOTFILES_END\n" >> ~/.bashrc
fi

echo "Done"
