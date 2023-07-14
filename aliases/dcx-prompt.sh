#!/bin/bash
set -e
export PATH="$PATH:$HOME/.fzf/bin"

export DEVCONTAINERX_SKIP_UPDATE=1 
dc_name=$(~/.local/bin/devcontainerx list | fzf --preview="~/.local/bin/devcontainerx show --name '{1}'" --header "devcontainer exec" --bind="ctrl-r:reload(~/.local/bin/devcontainerx list)") 

~/.local/bin/devcontainerx exec --name "$dc_name"

