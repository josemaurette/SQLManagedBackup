[cmdletbinding()]
Param
(
    $configs
)


foreach($config in $configs) {
    $serverInstance = $config.ServerInstance
    $storageAccountName = $config.StorageAccountName
    $accountKey = $config.AccountKey

	$corruptedBackups = @();

    $corruptedBackups = Get-CorruptedBackupBlobs $serverInstance

	$storageContext = Get-StorageContext -StorageAccountName $storageAccountName -AccountKey $accountKey

	foreach ($corruptedBackup in $corruptedBackups)
	{
	  Remove-Blob -StorageContext $storageContext -Container $corruptedBackup.Container -Blob $corruptedBackup.Blob
	}
   
}
