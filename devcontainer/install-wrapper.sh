#!/bin/bash
set -e

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function show_usage() {
	echo
	echo "install-wrapper.sh"
	echo
	echo "Installs devcontainer wrapper to alert user when using dotfiles-installed tools"
	echo "Wrappers are only created in a devcontainer environment (i.e. wehn DEV_CONTAINER is set)"
	echo
	echo -e "\t--tool-command\t(Required)Tool command (e.g. jq or az)"
	echo
}


# Set default values here
tool_command=""


# Process switches:
while [[ $# -gt 0 ]]
do
	case "$1" in
		--tool-command)
			tool_command=$2
			shift 2
			;;
		*)
			echo "Unexpected '$1'"
			show_usage
			exit 1
			;;
	esac
done

if [[ -z $tool_command ]]; then
	echo "--tool-command must be specified"
	show_usage
	exit 1
fi

original_command=$(which $tool_command)
if [[ $(command -v $tool_command > /dev/null; echo $?) == 1 ]]; then
	echo "Tool '$tool_command' not found - ensure installed before installing wrapper"
	exit 1
fi

if [[ -z DEVCONTAINER ]]; then
	# not in devcontainer
	exit 0
fi


echo "Creating wrapper for '$tool_command' ..."

# Ensure we have a wrappers folder
if [[ ! -d $script_dir/wrappers ]]; then
	echo "Creating wrappers folder"
	mkdir $script_dir/wrappers
	echo '*' > $script_dir/.gitignore
fi

# Create wrapper script
cat <<EOF > $script_dir/wrappers/$tool_command
#!/bin/bash
echo -e "\033[0;30;103m** using $tool_command from dotfiles **\033[0m" >&2
$original_command \$@
EOF
chmod +x $script_dir/wrappers/$tool_command

# Create alias for import during load
# Since aliases are ignored in scripts by default, this means that
# the wrappers are only used in scripts (not when running the tool interactively)
echo "alias $tool_command='$original_command'" >> $script_dir/wrappers/.aliases
