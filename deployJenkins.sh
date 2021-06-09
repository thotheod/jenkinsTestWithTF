#!/bin/bash

# Define variables  
red='\e[1;31m%s\e[0m\n'
green='\e[1;32m%s\e[0m\n'
blue='\e[1;34m%s\e[0m\n'



# set -euo pipefail
IFS=$'\n\t'

declare RESOURCEGROUPLOCATION="northeurope"
declare RGSUFFIX="testjenkins"
declare ACRNAME="acrtt2021060903"
declare -r JENKINS_USERNAME="demouser"
declare -r JENKINS_PASSWORD="demo@pass123"

SUBSCRIPTION=0a52391c-0d81-434e-90b4-d04f5c670e8a #MS


## 1. Set the right subscription
printf "$green"  "*** Setting the subsription to $SUBSCRIPTION***"
 az account set --subscription "$SUBSCRIPTION"
  

randomChar() {
    s=abcdefghijklmnopqrstuvxwyz0123456789
    p=$(( $RANDOM % 36))
    echo -n ${s:$p:1}
}

randomNum() {
    echo -n $(( $RANDOM % 10 ))
}

randomCharUpper() {
    s=ABCDEFGHIJKLMNOPQRSTUVWXYZ
    p=$(( $RANDOM % 26))
    echo -n ${s:$p:1}
}

echo "Checking for Jenkins deployment files"
if [[ ! -d "${PWD}/jenkins" ]]; then
    echo "Directory ${PWD}/jenkins does not exist. Deployment cannot proceed." 2>&1; exit 1;
fi

if [[ ! -f "${PWD}/jenkins/Dockerfile" ]]; then
    echo "Jenkins deployment files do not exist on your filesystem." 2>&1; exit 1;
fi

if [ ${#RGSUFFIX} -eq 0 ]; then
    RGSUFFIX="$(randomChar;randomChar;randomChar;randomNum;randomChar;randomChar;randomChar;randomNum;)"
fi

echo "Resource random suffix: "$RGSUFFIX

RGNAME="rg-${RGSUFFIX}"

RGEXISTS=$(az group show --name $RGNAME --query name)
if [ ${#RGEXISTS} -eq 0 ]; then
    echo "Resource group $RGNAME was not found. Creating resource group..."
    echo "Creating resource group $RGNAME in location $RESOURCEGROUPLOCATION"

    az group create --name $RGNAME --location $RESOURCEGROUPLOCATION
else
    echo "Using existing resource group $RGNAME."
fi


# 2. create ACR if not exists
tmp_CREATE_ACR=true

printf "$blue"  "check if some ACR already exist"
if [[ $(az acr list | jq 'length') -gt 0 ]]
then
    printf "$green"  "There is at least one ACR. check if the desired exists"
    tempACRNames=$(az acr list | jq -r '.[].name')
    for tmpACRName in $tempACRNames
    do
        if [ $ACRNAME = $tmpACRName ]
        then
            printf "$green"  "Desired ACR is already created with name: $tmpACRName"
            tmp_CREATE_ACR=false
        fi
    done
fi

if [ "$tmp_CREATE_ACR" = true ]
then
    printf "$green"  "check if $ACRNAME is valid"
    if [ $( az acr check-name -n  $ACRNAME | jq -r '.nameAvailable' ) = true ]; then
        printf "$green"  "ACR name: $ACRNAME is available. Create it now"
        az acr create -n $ACRNAME --resource-group $RGNAME --admin-enabled true --sku Basic
        printf "$green"  "$ACRNAME created"
    else
        printf "$green"  "ACR name: $ACRNAME is NOT available. Exit script"
        exit 1
    fi    
fi  

echo "Retrieving ACR information..."
ACRNAME=$(az acr list --resource-group $RGNAME --query [].name -o tsv)
echo "Found ACR at $ACRNAME."

if [ ${#ACRNAME} -eq 0 ]; then
    echo "Azure Container Registry name not found." 2>&1; exit 1;
fi


# # Make a temporary path for cloning from the existing git repos
 TEMPDIRNAME="temp$RGSUFFIX"

echo "Creating temporary directory $TEMPDIRNAME..."
mkdir $TEMPDIRNAME

FULLTEMPDIRPATH="$PWD/$TEMPDIRNAME"
FULLCURRENTPATH=$PWD


    
cd $FULLCURRENTPATH


# BUILD JENKINS
echo "Building JENKINS image..."
echo "Changing directory to $FULLCURRENTPATH/jenkins..."
cd "$FULLCURRENTPATH/jenkins"
az acr build --image devopsoh/jenkins:latest --registry $ACRNAME --file Dockerfile --build-arg JENKINS_USERNAME=${JENKINS_USERNAME} --build-arg JENKINS_PASSWORD=${JENKINS_PASSWORD} .

# DEPLOY JENKINS TO ACI
echo "Deploying jenkins container..."
az container create \
    --name "aci-${RGSUFFIX}" \
    --resource-group $RGNAME \
    --image "${ACRNAME}.azurecr.io/devopsoh/jenkins:latest" \
    --registry-login-server "${ACRNAME}.azurecr.io" \
    --registry-username $(az acr credential show --name $ACRNAME --query username -o tsv) \
    --registry-password $(az acr credential show --name $ACRNAME --query passwords[0].value -o tsv) \
    --dns-name-label "openhack${RGSUFFIX}jenkins" \
    --port 8080 \
    --query ipAddress.fqdn

cd $FULLCURRENTPATH

echo "Removing temporary files..."
rm -rf $FULLTEMPDIRPATH