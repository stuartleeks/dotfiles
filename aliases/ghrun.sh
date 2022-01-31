#!/bin/bash
set -e

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function show_usage() {
    echo
    echo "ghrun.sh"
    echo
    echo "Display the latest workflow execution for a PR - notifies on completion"
    echo
    echo -e "\t--workflow, -w\t(Optional)The name of the workflow to query for."
    echo
    echo "Use 'git config stuartleeks.ghrun.workflow workflow_name' to set the default workflow for a git repo"
    echo
}

# Set default values here
workflow_name=

# Process switches:
while [[ $# -gt 0 ]]
do
    case "$1" in
        -w|--workflow)
            workflow_name=$2
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

if [[ -z $workflow_name ]]; then 
    if [[ "0" == $(git config --get stuartleeks.ghrun.workflow > /dev/null; echo $?) ]]; then
        workflow_name=$(git config --get stuartleeks.ghrun.workflow) # Use the value of stuartleeks.ghrun.workflow git config value unless overridden by workflow switch
        if [[ -n $workflow_name ]]; then 
            echo "Filtering to workflow '$workflow_name' (from stuartleeks.ghrun.workflow git config value)"
        fi
    fi
else
    echo "Filtering to workflow '$workflow_name'"
fi

workflow_arg=
if [[ -n $workflow_name ]]; then
    workflow_arg="--workflow '$workflow_name'"
fi

# Get the latest run for the current branch *update to use JSON output once implemented - see below)
run_id=$(echo "$workflow_arg" | xargs gh run list | grep $(git rev-parse --abbrev-ref HEAD) | cut -d$'\t' -f 7 | head -n 1)

# Watch the run progress
gh run watch $run_id

# Create a temp file to capture the url in via a fake browser (change this to use JSON output once this is implemented: https://github.com/cli/cli/issues/3477)
temp_filename=$(mktemp)
# clean up the temp file on exit
function finish {
  rm "$temp_filename"
}
trap finish EXIT

# Use fake browser to capture run url
exit_code=$(BROWSER="$dir/save-args.sh \"$temp_filename\"" gh run view $run_id --web --exit-status > /dev/null; echo $?)
run_url=$(cat "$temp_filename" | head -n 1)

if [[ $exit_code == "0" ]]; then
    title="Run completed successfully"
else
    title="Run completed with exit code $exit_code"
fi

if [[ -z "$TOAST" ]]; then
    TOAST=toast.exe
fi

$TOAST \
    --app-id "GitHub" \
    --title "$title" \
    --message "$PWD" \
    --action "Open browser" --action-arg "$run_url"
