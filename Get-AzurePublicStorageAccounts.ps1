# Authenticate to your Azure account
Connect-AzAccount

# Get all subscriptions
$subscriptions = Get-AzSubscription

# Iterate through all subscriptions and get storage accounts with public access enabled
$results = @()
foreach ($subscription in $subscriptions) {
    Write-Host "Processing subscription: $($subscription.Name) - $($subscription.Id)"
    Set-AzContext -SubscriptionId $subscription.Id

    # Get all storage accounts in the subscription
    $storageAccounts = Get-AzStorageAccount

    # Iterate through storage accounts and check for public access
    foreach ($storageAccount in $storageAccounts) {
        $containers = Get-AzStorageContainer -Context $storageAccount.Context

        # Check if any container has public access enabled
        $publicContainers = $containers | Where-Object { $_.PublicAccess -ne 'Off' }

        if ($publicContainers) {
            $results += [PSCustomObject]@{
                "SubscriptionName" = $subscription.Name
                "SubscriptionId"   = $subscription.Id
                "StorageAccountName" = $storageAccount.StorageAccountName
                "ResourceGroupName" = $storageAccount.ResourceGroupName
                "PublicContainers" = ($publicContainers | ForEach-Object { $_.Name }) -join ", "
            }
        }
    }
}

# Output the results
$results | Format-Table -AutoSize

# Export the results to a CSV file
$csvFilePath = "PublicStorageAccounts.csv"
$results | Export-Csv -Path $csvFilePath -NoTypeInformation

Write-Host "Results saved to $csvFilePath"
