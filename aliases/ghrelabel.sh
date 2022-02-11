#!/bin/bash
set -e

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function show_usage() {
    echo
    echo "ghrelabel.sh"
    echo
    echo "Apply a label to a PR for a branch"
    echo
    echo -e "\t--label\t(Required)The name of the label to apply"
    echo -e "\t--pr\t(Optional)The number of the PR to apply the label to (defaults to PR for current branch)"
    echo
    echo "Use 'git config stuartleeks.ghrelabel.label label_name' to set the default label for a git repo"
    echo
}


# Set default values here
label_name=
pr_number=

# Process switches:
while [[ $# -gt 0 ]]
do
    case "$1" in
        --label)
            label_name=$2
            shift 2
            ;;
        --pr)
            pr_number=$2
            shift 2
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "Unexpected '$1'"
            show_usage
            exit 1
            ;;
    esac
done

if [[ -z $label_name ]]; then 
    if [[ "0" == $(git config --get stuartleeks.ghrelabel.label > /dev/null; echo $?) ]]; then
        label_name=$(git config --get stuartleeks.ghrelabel.label) # Use the value of stuartleeks.ghrelabel.label git config value unless overridden by workflow switch
        if [[ -n $label_name ]]; then 
            echo "Using label '$label_name' (from stuartleeks.ghrelabel.label git config value)"
        fi
    fi
fi

if [[ -z $label_name ]]; then
    echo "label must be specified"
    show_usage
    exit 1
fi

url=$(gh pr view --json url | jq -r .url)
if [[ "$url" =~ ^https://github.com/([^/]*)/([^/]*)/pull/([0-9]*) ]]; then
	owner=${BASH_REMATCH[1]}
	repo=${BASH_REMATCH[2]}
    if [[ -z $pr_number ]]; then
    	pr_number=${BASH_REMATCH[3]}
        echo "Using PR $pr_number from current branch"
    fi
else
	echo "Failed to parse PR url: '$url'"
	exit 1
fi

echo "Applying label '$label_name' to PR $pr_number..."

label_exists=$(gh pr view --json labels | jq -r ".labels | map(select(.name== \"$label_name\")) | length")
if [[ $label_exists == "1" ]]; then
	echo "Removing label..."
	gh api -X DELETE "/repos/$owner/$repo/issues/$pr_number/labels/$label_name"
fi

echo "Adding label..."
echo "{ \"labels\": [\"$label_name\"]}" | gh api -X POST "/repos/$owner/$repo/issues/$pr_number/labels" --input - 

echo "Done"

