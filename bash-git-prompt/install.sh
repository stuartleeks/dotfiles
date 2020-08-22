set -e

if [[ -d ~/.bash-git-prompt/ ]]; then
    echo "bash-git-prompt installed - exiting"
    exit 0
fi

echo "Installing bash-git-prompt..."

git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1

