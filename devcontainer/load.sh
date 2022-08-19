## add clip folder to path to override xsel/xclip with dev container versions!
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export PATH=$DIR/clip:$PATH
alias clip="xclip -i"

## add toast folder to path to make notify-send/toast scripts available!
export PATH=$DIR/toast:$PATH
export TOAST=toast

export AZBROWSE_SETTINGS_PATH="$DOTFILES_FOLDER/devcontainer/.azbrowse-settings.json"


# if wrappers folder exists, add to PATH
if [[ -d $DIR/wrappers ]]; then
	export PATH=$DIR/wrappers:$PATH
	if [[ -f $DIR/wrappers/.aliases ]]; then
		source $DIR/wrappers/.aliases
	fi
fi