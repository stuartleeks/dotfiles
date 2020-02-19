BASE_DIR=$(dirname "$0")

echo "Adding aliases to .bashrc..."
echo "source \"$BASE_DIR/aliases.sh\"" >> ~/.bashrc

bash install-bash-git-prompt.sh

echo "Done"
