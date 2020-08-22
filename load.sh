#
# This script is intended to be sourced from .bashrc
# It is added to .bashrc by install.sh
#

source "$DOTFILES_FOLDER/aliases/load.sh"
source "$DOTFILES_FOLDER/bash-git-prompt/load.sh"

if [[ -n $WSL_DISTRO_NAME ]]; then
    free-mem() { sudo "$DOTFILES_FOLDER/wsl/free-mem.sh"; }
fi

# TODO
# - completion for azbrowse if installed
# - completion for devcontainer-cli (dc) if installed
# - completion for kubectl (k) if installed
