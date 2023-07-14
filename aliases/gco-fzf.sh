#!/bin/bash
set -e

branch_name=$(git branch --sort=-committerdate \
    | fzf --bind 'ctrl-a:reload(git branch --all --sort=-committerdate)' --preview="git diff --color=always \$(git rev-parse HEAD) '{1}'" --header "git checkout")

if [[ -z "$branch_name" ]]; then
    # user pressed Esc
    echo "No branch selected - no action taken"
    exit
fi

if [[ "${branch_name:0:2}" == "* " ]]; then
    # fzf returns "* ..." for the currently selected item
    # i.e. we're already on that branch
    echo "Existing branch selected - no action taken"
    exit
fi

# strip "  " or from the beginning of the branch name (added by fzf)
branch_name=${branch_name##  }
if [[ -n "$branch_name" ]]; then
    # if branch_name starts with remotes/*/ then remove it
    branch_name=${branch_name#remotes/*/}
    git checkout "$branch_name"
fi
