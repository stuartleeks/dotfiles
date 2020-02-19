set -e

GIT_PROMPT_INSTALLED=$(cat ~/.bashrc | grep -q gitprompt.sh; echo $?)
if [[ "$GIT_PROMPT_INSTALLED" == "0" ]]; then
    echo "bash-git-prompt installed - exiting"
    exit 0
fi

echo "Installing bash-git-prompt..."

git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1

cat <<EOF >> ~/.bashrc
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source $HOME/.bash-git-prompt/gitprompt.sh
fi
EOF
