Function Remove-Blob {
    [cmdletbinding()]
    Param(
        [object] $StorageContext,
        [string] $Container,
		[string] $Blob
    )

   # Remove blob from Container passing the storage Context 
   Remove-AzureStorageBlob -Container $Container -Blob $Blob -Context $StorageContext -ErrorAction Ignore
}
