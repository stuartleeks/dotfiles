alias cls=clear
alias md=mkdir
alias cd..="cd .."

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# helper to reset the marker files to reinstall extensions on reloading the devcontainer
reset-vscode-extensions() { rm ~/.vscode-server/data/Machine/.installExtensionsMarker; rm ~/.vscode-server/data/Machine/.postCreateCommandMarker; }

function set-prompt() { echo -ne '\033]0;' $@ '\a'; }

# if [[ -x ~/.local/bin/devcontainerx ]]; then
if [[ $(command -v devcontainerx > /dev/null; echo $?) == 0 ]]; then
    alias dco="devcontainerx open-in-code"
    alias dce="devcontainerx exec --path . bash"

    source <(devcontainerx completion bash)

    alias dcx=devcontainerx
    source <(dcx completion bash)
    complete -F __start_devcontainerx dcx
fi

if [[ $(command -v devcontainer > /dev/null; echo $?) == 0 ]]; then
    alias dcb="devcontainer build --workspace-folder \$PWD"
    # alias dce="devcontainer exec --workspace-folder $PWD bash"
fi

if [[ $(command -v azbrowse > /dev/null; echo $?) == 0 ]]; then
    source <(azbrowse completion bash)
    alias azb=azbrowse
    complete -F __start_azbrowse azb
fi


if [[ $(command -v kubectl > /dev/null; echo $?) == 0 ]]; then
    alias k=kubectl
    source <(kubectl completion bash)
    complete -F __start_kubectl k
fi

if [[ $(command -v kind > /dev/null; echo $?) == 0 ]]; then
    source <(kind completion bash)
fi


if [[ $(command -v az > /dev/null; echo $?) == 0 ]]; then
    function get-alias() { az ad user list --filter "mail eq '$1'" --query [0].userPrincipalName -o tsv; }
    alias azlogin="az login --tenant 0a86e783-e82b-4ba0-8564-c79063f8672f"
fi

if [[ $(command -v thefuck > /dev/null; echo $?) == 0 ]]; then
    eval $(thefuck --alias grr)
fi

if [[ $(command -v gh > /dev/null; echo $?) == 0 ]]; then
    eval "$(gh completion -s bash)"
    
    # Original ghrun alias
    # alias ghrun="gh run list | grep \$(git rev-parse --abbrev-ref HEAD) | cut -d$'\t' -f 8 | xargs gh run watch && notify-send 'Run finished'"
    alias ghrun="$DIR/ghrun.sh"
    alias ghrelabel="$DIR/ghrelabel.sh"
fi

alias "gc"="git checkout"
alias "gc-"="git checkout -"
if [[ $(command -v fzf > /dev/null; echo $?) == 0 ]]; then
    # https://mastodon.social/@elijahmanor/109320029491309392
    alias gco="git branch --sort=-committerdate | fzf --preview=\"git diff --color=always \$(git rev-parse HEAD) '{1}'\" --header \"git checkout\" | xargs git checkout"
    if [[ $(command -v fd > /dev/null; echo $?) == 0 ]]; then
        alias fdf="fd --type f --hidden --exclude .git"
        alias fdff="fd --type f --hidden --exclude .git | fzf"
        if [[ $(command -v fzf > /dev/null; echo $?) == 0 ]]; then
            # https://mastodon.social/@elijahmanor/109314401963363668
            alias catf="fd --type f --hidden --exclude .git | fzf |xargs batcat"
        fi
    fi
fi

if [[ $(command -v python3 > /dev/null; echo $?) == 0 ]]; then
    alias dapr-log-format="$DIR/dapr-log-format.py"
fi

alias wait-for-network="$DIR/wait-for-network.sh"

alias wait-for-azdo-build="$DIR/wait-for-azdo-build.sh"


# if [[ -f ~/z/z.sh ]]; then
#     if [[ -z $DEV_CONTAINER ]]; then
#         # In a dev container we often override the HISTFILE location
#         # to preserve history across dev container instances
#         # If that's the case then piggy-back the Z_DATA on it :-)
#         if [[ -n $HISTFILE ]]; then
#             export Z_DATA="$(dirname $HISTFILE)/.z"
#         fi
#     fi
#     # source ~/z/z.sh
# fi

if [[ $(command -v batcat > /dev/null; echo $?) == 0 ]]; then
    alias cat=batcat
fi

alias printenvs="printenv | sort"


# export AZURE_CORE_OUTPUT=jsonc
export AZURE_CORE_OUTPUT=table


if [[ -z $DEV_CONTAINER ]]; then
    export AZBROWSE_SETTINGS_PATH="$DOTFILES_FOLDER/.config/.azbrowse-settings.json"
fi


source $DIR/jwt.sh

alias s="$DIR/show.sh"