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


# https://meyerweb.com/eric/thoughts/2020/09/29/polite-bash-commands/
please() {
	if [ "$1" ]; then
		sudo $@
	else
		sudo "$BASH" -c "$(history -p !!)"
	fi
}