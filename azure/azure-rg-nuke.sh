#!/bin/bash
set -e

# Array of resource groups which should not be automatically deleted
DO_NOT_DELETE_RESOURCE_GROUPS=("az-resourcegroup-nuke", "liveapplication-rg")

ALL_RESOURCE_GROUPS=$(az group list | jq -r '.[] | .name')
echo ">>>>>>  Executing azure-rg-nuke.sh <<<<<<<"

for resource_group in $ALL_RESOURCE_GROUPS
do
    if [[ " ${DO_NOT_DELETE_RESOURCE_GROUPS[*]} " =~ "$resource_group" ]]; then
        echo "### Skipping Deletion of Resource Group: '$resource_group' from DO NOT DELETE list ###"
    else
        echo "*** Deleting Resource Group: $resource_group ***"
        az group delete -n $resource_group --force-deletion-types Microsoft.Compute/virtualMachines -y
        echo "*** Deleted Resource Group: $resource_group succesffully ***"
    fi
done
echo ">>>>>>  Execution of azure-rg-nuke.sh completed <<<<<<<"