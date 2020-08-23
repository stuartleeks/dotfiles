alias cls=clear
alias md=mkdir
alias cd..="cd .."

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# helper to reset the marker files to reinstall extensions on reloading the devcontainer
reset-vscode-extensions() { rm ~/.vscode-server/data/Machine/.installExtensionsMarker; rm ~/.vscode-server/data/Machine/.postCreateCommandMarker; }

function set-prompt() { echo -ne '\033]0;' $@ '\a'; }

if [[ $(command -v devcontainer > /dev/null; echo $?) == 0 ]]; then
    source <(devcontainer completion bash)
    alias dc=devcontainer
    source <(devcontainer completion bash | sed s/devcontainer/dc/g)
fi

if [[ $(command -v azvbrowse > /dev/null; echo $?) == 0 ]]; then
    source <(azbrowse completion bash)
fi


if [[ $(command -v kubectl > /dev/null; echo $?) == 0 ]]; then
    alias k=kubectl
    source <(kubectl completion bash)
    source <(kubectl completion bash | sed s/kubectl/k/g)
fi

if [[ $(command -v kind > /dev/null; echo $?) == 0 ]]; then
    source <(kind completion bash)
fi