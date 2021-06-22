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
