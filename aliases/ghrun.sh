#!/bin/bash
set -e

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Get the latest run for the current branch *update to use JSON output once implemented - see below)
run_id=$(gh run list | grep $(git rev-parse --abbrev-ref HEAD) | cut -d$'\t' -f 7 | head -n 1)

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
