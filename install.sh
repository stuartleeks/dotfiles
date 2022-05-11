#!/bin/bash

#
# This script installs dependencies
# It is intended to be run to set up the dotfiles
# And adds to .bashrc to source the load.sh script 
#

BASE_DIR=$(dirname "$0")
BASE_DIR=$(cd $BASE_DIR; pwd)

sudo bash "$BASE_DIR/bash-completion/install.sh"

bash "$BASE_DIR/bash-git-prompt/install.sh"

if grep -q DOTFILES_FOLDER ~/.bashrc; then
    echo "dotfiles loader already in .bashrc - skipping"
else
    echo "Adding dotfiles loader to .bashrc..."
    echo -e "# DOTFILES_START" >> ~/.bashrc
    echo -e "DOTFILES_FOLDER=\"$BASE_DIR\"" >> ~/.bashrc
    if [[ -n $DEV_CONTAINER ]]; then
        echo -e "DEV_CONTAINER=1" >> ~/.bashrc
    fi
    echo -e "source \"$BASE_DIR/load.sh\"" >> ~/.bashrc
    echo -e "# DOTFILES_END\n" >> ~/.bashrc
fi

if [[ $(command -v socat > /dev/null; echo $?) == 1 ]]; then
    echo "Installing socat"
    sudo apt update && sudo apt install -y socat
fi

if [[ $(command -v azbrowse > /dev/null; echo $?) == 1 ]]; then
    echo "Installing azbrowse"
    mkdir -p ~/bin
    export AZBROWSE_LATEST=$(wget -O - -q https://api.github.com/repos/lawrencegripper/azbrowse/releases/latest | grep 'browser_' | cut -d\" -f4 | grep linux_amd64.tar.gz)
    wget "$AZBROWSE_LATEST"
    tar -C ~/bin -zxvf azbrowse_linux_amd64.tar.gz azbrowse
    chmod +x ~/bin/azbrowse
    rm azbrowse_linux_amd64.tar.gz
fi


if [[ ! -f ~/z/z.sh ]]; then
    echo "Installing z"
    git clone https://github.com/stuartleeks/z ~/z
fi

if [[ $(command -v batcat > /dev/null; echo $?) == 1 ]]; then
    echo "Installing batcat"
    sudo apt install -y batcat
fi

if [[ $(command -v jq > /dev/null; echo $?) == 1 ]]; then
    echo "Installing jq"
    sudo apt install -y jq
fi

if [[ $(command -v diff-so-fancy > /dev/null; echo $?) == 1 ]]; then
    echo "Installing diff-so-fancy"
    wget -q -O ~/bin/diff-so-fancy https://github.com/so-fancy/diff-so-fancy/releases/latest/download/diff-so-fancy
    chmod +x ~/bin/diff-so-fancy

    if [[ $(command -v git > /dev/null; echo $?) == 0 ]]; then
        echo "Configuring git to use diff-so-fancy"
        git config --global interactive.diffFilter "diff-so-fancy --patch"
    fi
fi


if [[ -n $WSL_DISTRO_NAME ]]; then
    "$BASE_DIR/wsl/install.sh"
fi

echo "Done"


