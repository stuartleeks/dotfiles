#!/bin/bash
set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# This script takes a 1Password secret reference and a list of character positions as arguments.
# It retrieves the secret value from 1Password and extracts the characters at the specified positions.
# The script then prints the extracted characters.
# e.g. "op-chars.sh op://my-vault/my-secret 1 3 5" will print the 1st, 3rd and 5th characters of the secret value.
# Note that the positions are 1-based, meaning that the first character is at position 1.
# Usage: op-chars.sh <secret-ref> <position1> <position2> ...

# Read the secret reference from the first argument
secret_ref="$1"
# check if the secret reference is empty
if [[ -z "$secret_ref" ]]; then
	echo "Error: No secret reference provided."
	exit 1
fi

# read the character positions from the remaining arguments
positions=("${@:2}")
# check if any positions were provided
if [[ ${#positions[@]} -eq 0 ]]; then
	read -a positions -p "Enter character positions (space-separated): "
	if [[ ${#positions[@]} -eq 0 ]]; then
		echo "Error: No positions provided."
		exit 1
	fi
fi

# check if we're signed in
if ! op whoami > /dev/null 2>&1; then
	echo "Not signed in to 1Password - signing in..."
	eval $(op signin)
	if ! op whoami > /dev/null 2>&1; then
		echo "Error: Failed to sign in to 1Password."
		exit 1
	fi
fi

# read the secret value from 1Password
secret_value=$(op read "$secret_ref")

echo "$secret_value" | $script_dir/get-chars.sh "${positions[@]}"
