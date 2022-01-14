if [[ ! -d ~/.local/wsl-hello-sudo ]]; then
    echo "Installing wsl-hello-sudo"
    mkdir -p ~/.local/wsl-hello-sudo
    wget -q -O ~/.local/wsl-hello-sudo/release.tar.gz http://github.com/nullpo-head/WSL-Hello-sudo/releases/latest/download/release.tar.gz
    (cd ~/.local/wsl-hello-sudo && tar xvf release.tar.gz)
    (cd ~/.local/wsl-hello-sudo/release && ./install.sh``)
fi
