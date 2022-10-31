#!/bin/bash

#
# This script is the "set up the apps" script :-)
#

BASE_DIR=$(dirname "$0")
BASE_DIR=$(cd $BASE_DIR; pwd)

mkdir -p ~/tmp
mkdir -p ~/utils

if [[ $(command -v azbrowse > /dev/null; echo $?) == 1 ]]; then
    echo "📦 Installing azbrowse"
    mkdir -p ~/bin
    export AZBROWSE_LATEST=$(wget -O - -q https://api.github.com/repos/lawrencegripper/azbrowse/releases/latest | grep 'browser_' | cut -d\" -f4 | grep linux_amd64.tar.gz)
    wget "$AZBROWSE_LATEST"
    tar -C ~/bin -zxvf azbrowse_linux_amd64.tar.gz azbrowse
    chmod +x ~/bin/azbrowse
    rm azbrowse_linux_amd64.tar.gz
else
    echo "✅ azbrowse already installed"
fi


if [[ -d ~/utils/tools-install ]]; then
    echo "🔁 Updating tools-install repo"
    (cd ~/utils/tools-install && git pull)
else
    echo "📦 Cloning tools-install repo"
    git clone https://github.com/stuartleeks/tools-install ~/utils/tools-install
fi

if [[ $(command -v az > /dev/null; echo $?) == 1 ]]; then
    ~/utils/tools-install/azure-cli.sh
else
    echo "✅ az already installed"
fi

if [[ $(command -v pip3 > /dev/null; echo $?) == 1 ]]; then
    echo "📦 Installing pip3"
    sudo apt install -y python3-pip
else
    echo "✅ pip3 already installed"
fi

if [[ $(command -v npm > /dev/null; echo $?) == 1 ]]; then
    ~/utils/tools-install/node.sh
else
    echo "✅ node/npm already installed"
fi

if [[ $(command -v tldr > /dev/null; echo $?) == 1 ]]; then
    echo "📦 Installing tldr"
    sudo npm install -g tldr
else
    echo "✅ tldr already installed"
fi

if [[ $(command -v thefuck > /dev/null; echo $?) == 1 ]]; then
    echo "📦 Installing thefuck"
    pip3 install thefuck
    mv ~/.config/thefuck/settings.py ~/.config/thefuck/settings-orig.py
    ln -s "${BASE_DIR}/.config/thefuck/settings.py" ~/.config/thefuck/settings.py
    mv ~/.config/thefuck/rules ~/.config/thefuck/rules-orig
    ln -s "${BASE_DIR}/.config/thefuck/rules" ~/.config/thefuck/rules
else
    echo "✅ thefuck already installed"
fi


if [[ $(command -v gh > /dev/null; echo $?) == 1 ]]; then
    echo "📦 Installing gh"
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install -y gh
else
    echo "📦 gh already installed - checking for updates"
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install -y gh
fi


if [[ -x ~/.local/binx/devcontainer ]]; then
    echo "✅ devcontainer-cli already installed"
else
    echo "📦 Installing devcontainer-cli"
    export OS=linux # also darwin
    export ARCH=amd64 # also 386
    wget -O ~/tmp/devcontainer-cli-install.sh https://raw.githubusercontent.com/stuartleeks/devcontainer-cli/main/scripts/install.sh
    chmod +x ~/tmp/devcontainer-cli-install.sh
    sudo -E ~/tmp/devcontainer-cli-install.sh
    rm -f  devcontainer-cli_linux_amd64.tar.gz
    mkdir -p ~/.local/binx
    mv ~/bin/devcontainer ~/.local/binx/devcontainer

    mkdir -p ~/.devcontainer-cli
    ln -s "${BASE_DIR}/.config/devcontainer-cli/devcontainer-cli.json" ~/.devcontainer-cli/devcontainer-cli.json
fi

if [[ -d ~/utils/vscode-dev-containers ]]; then
    echo "🔁 Updating vscode-dev-containers repo"
    (cd ~/utils/vscode-dev-containers && git pull)
else
    echo "📦 Cloning vscode-dev-containers repo"
    git clone https://github.com/microsoft/vscode-dev-containers ~/utils/vscode-dev-containers
fi

if [[ -d ~/utils/sl-devcontainers ]]; then
    echo "🔁 Updating sl-devcontainers repo"
    (cd ~/utils/sl-devcontainers && git pull)
else
    echo "📦 Cloning sl-devcontainers repo"
    git clone https://github.com/stuartleeks/devcontainers ~/utils/sl-devcontainers
fi

if [[ -L ~/Downloads ]]; then
    echo "✅ Downloads already symlinked"
else
    echo "📦 Creating Downloads symlink"
    win_profile=$(powershell.exe -Command 'Write-Host -NoNewLine ${env:USERPROFILE}')
    wsl_win_profile=$(wslpath $win_profile)
    ln -s ${wsl_win_profile}/Downloads/ ~/Downloads
fi

if [[ -L ~/OneDrive-leeksfamily ]]; then
    echo "✅ OneDrive-leeksfamily already symlinked"
else
    echo "📦 Creating OneDrive-leeksfamily symlink"
    win_profile=$(powershell.exe -Command 'Write-Host -NoNewLine ${env:USERPROFILE}')
    wsl_win_profile=$(wslpath $win_profile)
    ln -s ${wsl_win_profile}/OneDrive\ -\ leeksfamily/ ~/OneDrive-leeksfamily
fi

if [[ -L ~/OneDrive-Microsoft ]]; then
    echo "✅ OneDrive-Microsoft already symlinked"
else
    echo "📦 Creating OneDrive-Microsoft symlink"
    win_profile=$(powershell.exe -Command 'Write-Host -NoNewLine ${env:USERPROFILE}')
    wsl_win_profile=$(wslpath $win_profile)
    ln -s ${wsl_win_profile}/OneDrive\ -\ Microsoft/ ~/OneDrive-Microsoft
fi

if [[ -L ~/OneDrive ]]; then
    echo "✅ OneDrive already symlinked"
else
    echo "📦 Creating OneDrive symlink"
    win_profile=$(powershell.exe -Command 'Write-Host -NoNewLine ${env:USERPROFILE}')
    wsl_win_profile=$(wslpath $win_profile)
    ln -s ${wsl_win_profile}/OneDrive/ ~/OneDrive
fi


if [[ $(command -v fzf > /dev/null; echo $?) == 1 ]]; then
    echo "📦 Installing fzf"
    sudo apt-get install fzf
else
    echo "✅ fzf already installed"
fi

