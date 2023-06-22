#!/bin/bash

#
# This script installs dependencies
# It is intended to be run to set up the dotfiles
# And adds to .bashrc to source the load.sh script 
#

BASE_DIR=$(dirname "$0")
BASE_DIR=$(cd $BASE_DIR; pwd)

echo "dotfiles/install.sh - starting... (DEV_CONTAINER=$DEV_CONTAINER)"

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
    # Not installing socat as it is used in scripts within the dotfiles repo
    # Could consider allowing aliases in those scripts to avoid the warnings with the wrapper?
    # $BASE_DIR/devcontainer/install-wrapper.sh --tool-command jq
fi

if [[ $(command -v azbrowse > /dev/null; echo $?) == 1 ]]; then
    echo "Installing azbrowse"
    mkdir -p ~/bin
    export AZBROWSE_LATEST=$(wget -O - -q https://api.github.com/repos/lawrencegripper/azbrowse/releases/latest | grep 'browser_' | cut -d\" -f4 | grep linux_amd64.tar.gz)
    wget "$AZBROWSE_LATEST"
    tar -C ~/bin -zxvf azbrowse_linux_amd64.tar.gz azbrowse
    chmod +x ~/bin/azbrowse
    rm azbrowse_linux_amd64.tar.gz
    $BASE_DIR/devcontainer/install-wrapper.sh --tool-command azbrowse
fi


# if [[ ! -f ~/z/z.sh ]]; then
#     echo "Installing z"
#     git clone https://github.com/stuartleeks/z ~/z
# fi

if [[ $(command -v batcat > /dev/null; echo $?) == 1 ]]; then
    echo "Installing batcat"
    sudo apt install -y bat
fi

if [[ $(command -v jq > /dev/null; echo $?) == 1 ]]; then
    echo "Installing jq"
    sudo apt install -y jq
    $BASE_DIR/devcontainer/install-wrapper.sh --tool-command jq
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

if [[ -n $DEV_CONTAINER ]]; then
    if [[ $(command -v thefuck > /dev/null; echo $?) == 1 ]]; then
        installed=0
        if [[ $(command -v pip > /dev/null; echo $?) == 0 ]]; then
            echo "Installing thefuck (using pip)"
            pip install thefuck
            installed=1
        fi
        if [[ $(command -v pip3 > /dev/null; echo $?) == 0 ]]; then
            echo "Installing thefuck (using pip3)"
            pip3 install thefuck
            installed=1
        fi
        if [[ $installed == 0 ]]; then
            if [[ -f ~/.config/thefuck/settings.py ]]; then
                mv ~/.config/thefuck/settings.py ~/.config/thefuck/settings-orig.py
            fi
            if [[ -f ~/.config/thefuck/rules ]]; then
                mv ~/.config/thefuck/rules ~/.config/thefuck/rules-orig
            fi
            mkdir -p ~/.config/thefuck
            ln -s "${BASE_DIR}/.config/thefuck/settings.py" ~/.config/thefuck/settings.py
            ln -s "${BASE_DIR}/.config/thefuck/rules" ~/.config/thefuck/rules
        else
            echo "thefuck not installed (pip not found)"
        fi
    fi


    if [[ $(command -v dig > /dev/null; echo $?) == 1 ]]; then
        echo "Installing dig"
        sudo apt udpate
        sudo apt install -y dnsutils
        $BASE_DIR/devcontainer/install-wrapper.sh --tool-command dig
    fi
fi

if [[ -n $WSL_DISTRO_NAME ]]; then
    "$BASE_DIR/wsl/install.sh"
fi

if [[ $(command -v fzf > /dev/null; echo $?) == 1 ]]; then
    echo "📦 Installing fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi
if [[ $(command -v fd > /dev/null; echo $?) == 1 ]]; then
    # https://github.com/sharkdp/fd#installation
    echo "📦 Installing fd"
    sudo apt install fd-find
    mkdir -p ~/.local/bin
    ln -s $(which fdfind) ~/.local/bin/fd
fi



# TODO - add an upgrade flag
# upgrading git (need to check if apt-repository already added or not):
# add-apt-repository ppa:git-core/ppa # apt update; apt install git

echo "dotfiles/install.sh - done."
