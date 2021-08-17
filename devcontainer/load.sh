if [[ -n $DEV_CONTAINER ]]; then
    ## In a dev container
    ## add clip folder to path to override xsel/xclip with dev container versions!
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    export PATH=$DIR/clip:$PATH
fi

if [[ -n $DEV_CONTAINER ]]; then
    ## In a dev container
    ## add toast folder to path to make notify-send/toast scripts available!
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    export PATH=$DIR/toast:$PATH
    export TOAST=toast
fi

export AZBROWSE_SETTINGS_PATH="$DOTFILES_FOLDER/devcontainer/.azbrowse-settings.json"
