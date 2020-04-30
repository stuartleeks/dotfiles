#!/bin/bash

BASE_DIR=$(dirname "$0")

bash "$BASE_DIR/install-bash-completion.sh"

echo "Adding aliases to .bashrc..."
echo -e "source \"$BASE_DIR/aliases.sh\"\n" >> ~/.bashrc


bash install-bash-git-prompt.sh

echo "Done"
