#!/bin/bash

# read more here https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage
# we reccomend env variables and keyvault but here we go the easy way

# Define variables  
red='\e[1;31m%s\e[0m\n'
green='\e[1;32m%s\e[0m\n'
blue='\e[1;34m%s\e[0m\n'

# set -euo pipefail
IFS=$'\n\t'

LOCATION="northeurope"
SUBSCRIPTION=0a52391c-0d81-434e-90b4-d04f5c670e8a #MS
RESOURCE_GROUP_NAME=TFstate
STORAGE_ACCOUNT_NAME=tfstate$RANDOM
CONTAINER_NAME=tfstate


## 1. Set the right subscription
printf "$blue"  "*** Setting the subsription to $SUBSCRIPTION***"
 az account set --subscription "$SUBSCRIPTION"
# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

printf "$green"   "storage_account_name: $STORAGE_ACCOUNT_NAME"
printf "$green"   "container_name: $CONTAINER_NAME"
printf "$green"   "access_key: $ACCOUNT_KEY"

# storage_account_name: tfstate26116
# container_name: tfstate
# access_key: R3OIrPyhUr6js4v5yAn++Deys9enoMJaG74J6S7X/uAwFxQN06k8wPL9ZTZGJnVt0ArwKBwcVbZGe03vXrzOXA==

export ARM_ACCESS_KEY=R3OIrPyhUr6js4v5yAn++Deys9enoMJaG74J6S7X/uAwFxQN06k8wPL9ZTZGJnVt0ArwKBwcVbZGe03vXrzOXA==