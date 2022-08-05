#!/bin/bash
set -e

function show_usage() {
  echo
  echo "$0"
  echo
  echo "Tidy up VNET peerings (i.e. remove disconnected peerings)"
  echo
}


echo "Looking up resource group name from Terraform output..."
rg_name=$(jq -r ".core_resource_group_name.value" < templates/core/tre_output.json)
tre_id=${rg_name/rg-/}

for disconnected_vnet in $(az network vnet peering list --resource-group "$rg_name" --vnet-name "vnet-$tre_id" --query "[?peeringState=='Disconnected'].name" -o tsv);
do 
  echo "Deleting $disconnected_vnet..." 
  az network vnet peering delete --resource-group "$rg_name" --vnet-name "vnet-$tre_id" --name "$disconnected_vnet"
done

echo "done"
