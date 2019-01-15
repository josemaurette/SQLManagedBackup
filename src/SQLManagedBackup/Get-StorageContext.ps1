Function Get-StorageContext {
    [cmdletbinding()]
    Param(
        [string] $StorageAccountName,
        [string] $AccountKey
    )

# Create a new storage account context using an ARM storage account  
$storageContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $AccountKey

return $storageContext
}
