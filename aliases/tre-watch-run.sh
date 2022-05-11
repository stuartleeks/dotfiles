#!/bin/bash
set -e

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


function show_usage() {
    echo
    echo "$0"
    echo
    echo "Display the latest workflow execution for a PR - notifies on completion"
    echo
    echo
}

# Set default values here

# Process switches:
while [[ $# -gt 0 ]]
do
    case "$1" in
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


# Get comments for the PR associated with the current branch
# then find the latest message from the github-actions[bot] with a run url
pr_number=$(gh pr view --json number --jq .number)
echo "Got PR: $pr_number"
comment_json=$(gh api /repos/microsoft/AzureTRE/issues/${pr_number}/comments --paginate)

latest_run_id=$(echo $comment_json | jq -r '[map(select(.user.login=="github-actions[bot]")) | .[].body] | if length == 0 then empty else last end | capture("/actions/runs/(?<run_id>[0-9]+)") | .run_id')

if [[ -z $latest_run_id ]]; then
    echo "Failed to find run id for PR"
    exit 1
fi

echo "Got run_id: $latest_run_id"


# Watch the run progress
gh run watch $latest_run_id

run_result=$(gh run view $latest_run_id --json conclusion,url)
run_status=$(echo $run_result | jq -r .conclusion)
run_url=$(echo $run_result | jq -r .url)

title="TRE Run completed: $run_status "

if [[ -z "$TOAST" ]]; then
    TOAST=toast.exe
fi

$TOAST \
    --app-id "GitHub" \
    --title "$title" \
    --message "$PWD" \
    --action "Open browser" --action-arg "$run_url"
