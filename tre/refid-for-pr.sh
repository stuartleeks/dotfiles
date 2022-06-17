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

gh pr view $pr_number --json comments | jq -r '[.comments | map(select(.author.login == "github-actions")) | .[].body | capture("refid `(?<refid>[a-f0-9]+)`") | .refid] | last'
