#!/bin/bash

function show_usage() {
  echo
  echo "refid-for-pr.sh"
  echo
  echo "Gets the refid for a PR (requires 'gh')"
  echo
  echo -e "\t--pr\t(Optional)The PR number. Defaults to the PR for the current branch"
  echo
}


# Set default values here
pr_number=""

# Process switches:
while [[ $# -gt 0 ]]
do
  case "$1" in
    --pr)
      pr_number=$2
      shift 2
      ;;
    *)
      echo "Unexpected '$1'"
      show_usage
      exit 1
      ;;
  esac
done

run_id=$(gh pr view $pr_number --json comments | jq -r '[.comments | map(select(.author.login == "github-actions")) | .[].body | capture("/runs/(?<refid>[0-9]+)") | .refid] | last')

echo "run_id: $run_id"
if [[ -z "$run_id" ]]; then
  echo "No run found for PR $pr_number"
  exit 1
fi

# Watch the run progress
gh run watch $run_id

status=$(gh run view $run_id --json conclusion --jq .conclusion)

if [[ $status == "success" ]]; then
    title="Run completed successfully"
else
    title="Run completed with conclusion '$status'"
fi

if [[ -z "$TOAST" ]]; then
    TOAST=toast.exe
fi

$TOAST \
    --app-id "GitHub" \
    --title "$title" \
    --message "$PWD" \
    --action "Open browser" --action-arg "$run_url"

