Function Get-SharedAccessSignature {
    [cmdletbinding()]
    Param(
        [string] $StorageAccountName,
        [string] $AccountKey,
        [string] $PolicyName,
        [string] $ContainerName 
    )

# Create a new storage account context using an ARM storage account  
$storageContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $AccountKey

$result=Set-AzureStorageContainerStoredAccessPolicy -Container $ContainerName -Policy $PolicyName -Context $storageContext -ExpiryTime ((Get-Date).AddDays(730)) -Permission rwdl

# Gets the Shared Access Signature for the policy  
$sas = New-AzureStorageContainerSASToken -name $ContainerName -Policy $PolicyName -Context $storageContext
return $($sas.Substring(1))
}
