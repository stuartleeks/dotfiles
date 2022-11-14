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

# if [[ $(command -v devcontainerx > /dev/null; echo $?) == 0 ]]; then
if [[ -x ~/.local/binx/devcontainer ]]; then
    alias dc=$HOME/.local/binx/devcontainer
    source <(dc completion bash)
    complete -F __start_devcontainer dc

    alias devcontainerx=~/.local/binx/devcontainer
    source <(devcontainerx completion bash)
    complete -F __start_devcontainer devcontainerx

    alias dce="dc exec bash"
fi

if [[ $(command -v devcontainer > /dev/null; echo $?) == 0 ]]; then
    alias dco="devcontainer open"
    alias dcb="devcontainer build"
fi

if [[ $(command -v devcontainer-insiders > /dev/null; echo $?) == 0 ]]; then
    alias dco-i="devcontainer-insiders open"
    alias dcb-i="devcontainer-insiders build"
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

if [[ $(command -v fzf > /dev/null; echo $?) == 0 ]]; then
    # https://mastodon.social/@elijahmanor/109320029491309392
    alias gco="git branch --sort=-committerdate | fzf --preview=\"git diff --color=always $(git rev-parse HEAD) '{1}'\" --header \"git checkout\" | xargs git checkout"
    if [[ $(command -v fd > /dev/null; echo $?) == 0 ]]; then
        alias fdf="fd --type f --hidden --exclude .git"
        alias fdff="fd --type f --hidden --exclude .git | fzf"
        if [[ $(command -v fzf > /dev/null; echo $?) == 0 ]]; then
            # https://mastodon.social/@elijahmanor/109314401963363668
            alias catf="fd --type f --hidden --exclude .git | fzf |xargs batcat"
        fi
    fi
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
