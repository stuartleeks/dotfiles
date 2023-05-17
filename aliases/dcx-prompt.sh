#!/bin/bash
set -e

dc_name=$(~/.local/bin/devcontainerx list | fzf --preview="~/.local/bin/devcontainerx show --name '{1}'" --header "devcontainer exec") 

~/.local/bin/devcontainerx exec --name "$dc_name"

