#!/bin/bash
set -e

function show_usage() {
  echo
  echo "$0"
  echo
  echo "Check an environment health"
  echo
  echo -e "\t--ref-id\t(Optional) The refid from a PR build. If specified, the password for that environment is retrieved. Cannot be used with --main"
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
  echo "Looking up resource group name from Terraform output..."
  rg_name=$(jq -r ".core_resource_group_name.value" < templates/core/tre_output.json)
  tre_id=${rg_name/rg-/}
fi

location=$(echo "${az_args[@]}" | xargs az group show --name "$rg_name" --query location --output tsv)

echo "Using TRE_ID '$tre_id' (location $location)"
echo

set +e

echo "Checking RP VMSS instance health... "
vmss_instance_response=$(echo "${az_args[@]}" | xargs az vmss get-instance-view  --resource-group "$rg_name" --name "vmss-rp-porter-$tre_id" --instance-id '*' --output json)
vmss_instance_count=$(echo $vmss_instance_response | jq -r 'length')
for ((i=0; i < $vmss_instance_count; i++))
do
  vmss_instance_name=$(echo $vmss_instance_response | jq --argjson i $i -r '.[$i].computerName')
  vmss_instance_code=$(echo $vmss_instance_response | jq --argjson i $i -r '.[$i].vmHealth.status.code')
  vmss_instance_displayStatus=$(echo $vmss_instance_response | jq --argjson i $i -r '.[$i].vmHealth.status.displayStatus')
  vmss_instance_message=$(echo $vmss_instance_response | jq --argjson i $i -r '.[$i].vmHealth.status.message')
  echo -e -n "\t$vmss_instance_name... "
  if [[ "$vmss_instance_code" == "HealthState/healthy" ]]; then
    echo "✅ $vmss_instance_displayStatus"
  else
    echo "❌ $vmss_instance_displayStatus ($vmss_instance_message)"
  fi
done

echo "Checking API health... "
api_health=$(curl -s --insecure -X GET https://$tre_id.$location.cloudapp.azure.com/api/health)
api_health_service_count=$(echo "$api_health" | jq -r '.services | length')
for ((i=0; i < $api_health_service_count; i++))
do
  service_name=$(echo "$api_health" | jq --argjson i $i -r '.services[$i].service')
  service_status=$(echo "$api_health" | jq --argjson i $i -r '.services[$i].status')
  service_message=$(echo "$api_health" | jq --argjson i $i -r '.services[$i].message')
  echo -e -n "\t$service_name..."
  if [[ "$service_status" == "OK" ]]; then
    echo "✅ $service_message"
  else
    echo "❌ $service_message"
  fi
done

echo "Checking App Gateway health... "
appgw_health=$(echo "${az_args[@]}" | xargs az network application-gateway show-backend-health --resource-group "rg-$tre_id" --name "agw-$tre_id" --output json)
appgw_health_pool_count=$(echo "$appgw_health" | jq -r '.backendAddressPools | length')
for ((i=0; i < $appgw_health_pool_count; i++))
do
  pool_name=$(echo "$appgw_health" | jq --argjson i $i -r '.backendAddressPools[$i].backendAddressPool.id | split("/") | last')
  pool_unhealthy_servers=$(echo "$appgw_health" | jq --argjson i $i -r -c '.backendAddressPools[$i].backendHttpSettingsCollection | .[] | .servers | map(select(.health != "Healthy"))')
  echo -e -n "\t $pool_name..."
  if [[ "$pool_unhealthy_servers" == "[]" ]]; then
    echo "✅"
  else
    echo "❌: $pool_unhealthy_servers"
  fi
done
