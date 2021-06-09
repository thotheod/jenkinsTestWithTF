#!/bin/bash

# Define variables  
red='\e[1;31m%s\e[0m\n'
green='\e[1;32m%s\e[0m\n'
blue='\e[1;34m%s\e[0m\n'

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret 

# set -euo pipefail
IFS=$'\n\t'

declare RESOURCEGROUPLOCATION="northeurope"
declare RGSUFFIX="testjenkins"
declare ACRNAME="acrtt2021060903"
declare -r JENKINS_USERNAME="demouser"
declare -r JENKINS_PASSWORD="demo@pass123"

SUBSCRIPTION=0a52391c-0d81-434e-90b4-d04f5c670e8a #MS


## 1. Set the right subscription
printf "$blue"  "*** Setting the subsription to $SUBSCRIPTION***"
 az account set --subscription "$SUBSCRIPTION"

printf "$blue"  "*** create the SP ***"
 az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$SUBSCRIPTION"

# {
#   "appId": "709dd768-92b4-43d6-b6e9-fe0578960fc8",            client_id 
#   "displayName": "azure-cli-2021-06-09-20-34-43",  
#   "name": "http://azure-cli-2021-06-09-20-34-43",  
#   "password": "2IBBeD5i-rLN4bvqNR9Hge848AP6wlvj5o",           client_secret 
#   "tenant": "72f988bf-86f1-41af-91ab-2d7cd011db47"            tenant_id 
# }

# Terraform App Registered
# Application (client) ID         763b1382-ecb3-4595-894a-d449d31c7888
# Dir TenantID: 72f988bf-86f1-41af-91ab-2d7cd011db47
# TFSecret value  ~-cAj8b-qytf21w2U-hHR3gBmZQIY28_44
# TFSecretID: 960c90ec-76bb-4e76-b48d-7ae3b3614bf8
# Expiration 9/6/23