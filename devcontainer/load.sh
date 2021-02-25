if [[ -n $DEV_CONTAINER ]]; then
    ## In a dev container
    ## add clip folder to path to override xsel/xclip with WSL versions!
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    export PATH=$DIR/clip:$PATH
fi

export AZBROWSE_SETTINGS_PATH="$DOTFILES_FOLDER/devcontainer/.azbrowse-settings.json"
