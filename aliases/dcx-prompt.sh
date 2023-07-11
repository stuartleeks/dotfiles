#!/bin/bash
set -e
export PATH="$PATH:$HOME/.fzf/bin"

dc_name=$(~/.local/bin/devcontainerx list | fzf --preview="~/.local/bin/devcontainerx show --name '{1}'" --header "devcontainer exec") 

DEVCONTAINERX_SKIP_UPDATE=1 ~/.local/bin/devcontainerx exec --name "$dc_name"

