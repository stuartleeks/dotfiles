#!/bin/bash
set -e

# progress output is directed to stderr so that stdout only contains the password (e.g. for piping to the clipboard :-D)

function show_usage() {
  echo
  echo "$0"
  echo
  echo "Get VMSS password"
  echo
  echo -e "\t--ref-id\t(Optional)The refid from a PR build. If specified, the password for that environment is retrieved, otherwise the passowrd for the local env is retrieved"
  echo
}


# Set default values here
ref_id=""
az_args=()

# Process switches:
while [[ $# -gt 0 ]]
do
  case "$1" in
    --ref-id)
      ref_id=$2
      shift 2
      ;;
    *)
      echo "Unexpected '$1'"
      show_usage
      exit 1
      ;;
  esac
done

if [[ -z "$ref_id" ]]; then
  echo "Looking up KeyVault name from Terraform output..."
  kv_name=$(cat templates/core/tre_output.json | jq -r ".keyvault_name.value")
else
  # Set kv_name
  kv_name="kv-tre$ref_id"
  # Set correct subscription
  az_args+=('--subscription' 'joalmeid-osstrecicd')
fi

echo "KeyVault name: $kv_name" >&2

upn=$(az ad signed-in-user show --query userPrincipalName -o tsv)
echo "Ensuring permissions for '$upn' ..."  >&2
echo "${az_args[@]}" | xargs az keyvault set-policy --name "$kv_name" --secret-permissions all --upn "$upn" 1>&2

echo "Getting secret..."  >&2
echo "${az_args[@]}" | xargs az keyvault secret show --vault-name "$kv_name" --name resource-processor-vmss-password --query value --output tsv
