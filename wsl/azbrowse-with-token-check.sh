#!/bin/bash

SIGNED_IN=$(az account  get-access-token > /dev/null 2>&1; echo $?)
if [[ "$SIGNED_IN" != "0" ]]; then
    echo "No token or not signed in. Launching browser..."
    # use hack from https://github.com/Azure/azure-cli/issues/14656#issuecomment-760794232
    # Should be fine to remove once this is merged: https://github.com/Azure/azure-cli/pull/16556
    DISPLAY=:0 az login > /dev/null 2>&1
fi

azbrowse --subscription mpeck-stuartle
