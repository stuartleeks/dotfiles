#
# This script is intended to be sourced from .bashrc
# It is added to .bashrc by install.sh
#

export PATH=$PATH:~/bin

source "$DOTFILES_FOLDER/aliases/load.sh"
source "$DOTFILES_FOLDER/bash-completion/load.sh"
source "$DOTFILES_FOLDER/bash-git-prompt/load.sh"

if [[ -n $WSL_DISTRO_NAME ]]; then
    source "$DOTFILES_FOLDER/wsl/load.sh"
    free-mem() { sudo "$DOTFILES_FOLDER/wsl/free-mem.sh"; }
fi

if (command -v go > /dev/null); then
    source "$DOTFILES_FOLDER/go/load.sh"
fi

# TODO
# - completion for azbrowse if installed
# - completion for devcontainer-cli (dc) if installed
# - completion for kubectl (k) if installed
