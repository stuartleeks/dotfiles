#!/bin/bash

#
# This script installs dependencies
# It is intended to be run to set up the dotfiles
# And adds to .bashrc to source the load.sh script 
#

BASE_DIR=$(dirname "$0")

bash "$BASE_DIR/install-bash-completion.sh"

bash "$BASE_DIR/install-bash-git-prompt.sh"

# TODO - mostly want to set git-aliases in codespaces
# Don't want to set on install as it breaks gitconfig integration in devcontainers
# bash "$BASE_DIR/git-aliases.sh"

echo "Adding dotfiles loader to .bashrc..."
echo -e "DOTFILES_FOLDER=\"$BASE_DIR\"\n" >> ~/.bashrc
echo -e "source \"$BASE_DIR/load.sh\"\n" >> ~/.bashrc

echo "Done"
