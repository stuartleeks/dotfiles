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
    complete -F __start_devcontainer dc

    alias dco="devcontainer open-in-code ."
    alias dce="devcontainer exec bash"
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
