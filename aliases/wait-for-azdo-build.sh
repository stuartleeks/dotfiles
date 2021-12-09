#!/bin/bash

function show_usage() {
  echo
  echo "wait-for-azdo-build.sh"
  echo
  echo "wait-for-azdo-build"
  echo
  echo -e "\t--id\t(Required)The build ID"
  echo
}


# Set default values here
build_id=""


# Process switches:
while [[ $# -gt 0 ]]
do
  case "$1" in
    --id)
      build_id=$2
      shift 2
      ;;
    *)
      echo "Unexpected '$1'"
      show_usage
      exit 1
      ;;
  esac
done


if [[ -z $build_id ]]; then
  echo "--id must be specified"
  show_usage
  exit 1
fi


status="uknown"
while true
do
  status=$(az pipelines runs show --id $build_id  -o tsv --query status)
  [[ $status == "completed" ]] && break
  echo "Waiting (status=${status})..."
  sleep 5s
done

result=$(az pipelines runs show --id $build_id  -o tsv --query result)
title="Build completed: ${result}"
run_url="https://dev.azure.com/pubsecsolutions/Government/_build/results?buildId=${build_id}"

if [[ -z "$TOAST" ]]; then
    TOAST=toast.exe
fi

$TOAST \
    --app-id "Azure DevOps" \
    --title "$title" \
    --message "$PWD" \
    --action "Open browser" --action-arg "$run_url"
