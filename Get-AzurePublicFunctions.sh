#!/bin/bash

# Login to Azure account
az login

# Get all subscriptions
subscriptions=$(az account list --all --query "[].id" -o tsv)

# Loop through each subscription
for subscription in $subscriptions; do
    #echo "Subscription: $subscription"
    az account set --subscription $subscription

    # Get all resource groups
    resourceGroups=$(az group list --query "[].name" -o tsv)

    # Loop through each resource group
    for resourceGroup in $resourceGroups; do
        #echo "Resource Group: $resourceGroup"

        # Get all function apps in the resource group
        functionApps=$(az functionapp list --resource-group $resourceGroup --query "[].name" -o tsv)

        # Loop through each function app
        for functionApp in $functionApps; do
            #echo "Function App: $functionApp"

            # Get all web endpoints with public access enabled
            webEndpoints=$(az functionapp show --name $functionApp --resource-group $resourceGroup --query "hostNames[]" -o tsv)

            # Print all web endpoints with public access enabled
            echo "Web Endpoints:"
            echo "$webEndpoints"
        done
    done
done
