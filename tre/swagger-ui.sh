#!/bin/bash
set -e

# progress output is directed to stderr so that stdout only contains the URL (e.g. for piping to the clipboard :-D)

function show_usage() {
  echo
  echo "$0"
  echo
  echo "Get the swagger ui link for a given environment"
  echo
  echo -e "\t--ref-id\t(Optional) The refid from a PR build. If specified, the URL for that environment is retrieved. Cannot be used with --main"
  echo -e "\t--main\t(Optional) Use the main environment. Cannot be used with --ref-id"
  echo -e "\t (defaults to local env if neither --ref-id nor --main is specified)"
  echo
}


# Set default values here
ref_id=""
use_main=1
az_args=()

# Process switches:
while [[ $# -gt 0 ]]
do
  case "$1" in
    --ref-id)
      ref_id=$2
      shift 2
      ;;
    --main)
      use_main=0
      shift 1
      ;;
    *)
      echo "Unexpected '$1'"
      show_usage
      exit 1
      ;;
  esac
done

if [[ "$use_main" == "0" ]]; then
  if [[ -n "$ref_id" ]]; then
    echo "Cannot use --main and --ref-id"
    exit 1
  fi
  # Set rg_name etc
  tre_id="maintre1"
  rg_name="rg-$tre_id"
  # Set correct subscription
  az_args+=('--subscription' 'joalmeid-osstrecicd')
elif [[ -n "$ref_id" ]]; then
  # Set rg_name etc
  tre_id="tre$ref_id"
  rg_name="rg-$tre_id"
  # Set correct subscription
  az_args+=('--subscription' 'joalmeid-osstrecicd')
else
  echo "Looking up resource group name from Terraform output..." >&2
  rg_name=$(jq -r ".core_resource_group_name.value" < templates/core/tre_output.json)
  tre_id=${rg_name/rg-/}
fi

location=$(echo "${az_args[@]}" | xargs az group show --name "$rg_name" --query location --output tsv)

echo "https://$tre_id.$location.cloudapp.azure.com/api/docs"
