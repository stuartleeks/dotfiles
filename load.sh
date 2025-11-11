#
# This script is intended to be sourced from .bashrc
# It is added to .bashrc by install.sh
#

export PATH=$PATH:~/bin:~/.local/bin

if [[ -n "$_VSCODE_COPILOT" ]]; then
    # Add this to VSCode settings.json:
    # "chat.tools.terminal.terminalProfile.linux": {
    # 	"path": "bash",
    # 	"env": {
    # 		"_VSCODE_COPILOT": "true"
    # 	}
    # }
    echo "VSCode Copilot detected, skipping load.sh"
    return
fi

source "$DOTFILES_FOLDER/aliases/load.sh"
source "$DOTFILES_FOLDER/bash-completion/load.sh"
source "$DOTFILES_FOLDER/bash-git-prompt/load.sh"

if [[ -n $WSL_DISTRO_NAME ]]; then
    source "$DOTFILES_FOLDER/wsl/load.sh"
fi

if (command -v go > /dev/null); then
    source "$DOTFILES_FOLDER/go/load.sh"
fi

if (command -v git > /dev/null); then
    source "$DOTFILES_FOLDER/git/load.sh"
fi

if [[ -n $DEV_CONTAINER ]]; then
    source "$DOTFILES_FOLDER/devcontainer/load.sh"
fi

if [[ -z $DEV_CONTAINER ]];then
    TZ='Europe/London'; export TZ
fi

source "$DOTFILES_FOLDER/tre/load.sh"
