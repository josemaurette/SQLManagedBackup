[cmdletbinding()]
Param
(
    $configs
)


foreach($config in $configs) {
    $serverInstance = $config.ServerInstance
    $enableDatabases = $config.EnableDatabases
    $disableDatabases = $config.DisableDatabases
    $backupUrl = $config.BackupUrl
    $storageAccountName = $config.StorageAccountName
    $accountKey = $config.AccountKey
    $containerName = $config.ContainerName
    $policyName = $config.PolicyName
    $retention = $config.DefaultRetention
    $FullBackupFreqType = $config.DefaultFullBackupFreqType
    $backupBeginTime = $config.DefaultBackupBeginTime
    $logBackupFreq = $config.DefaultLogBackupFreq
    $StaggeredHour=$config.StaggeredIntervalHour
    $StartHour =  [datetime]$backupBeginTime
    $i = 0

    $results = Get-NonAGDatabases -ServerInstance $serverInstance 

    Write-Verbose  $serverInstance 


    $secret = Get-SharedAccessSignature -StorageAccountName $storageAccountName -AccountKey $accountKey -ContainerName $containerName -PolicyName $policyName
    Set-ManagedBackupCredential -ServerInstance $serverInstance -Credential $backupUrl -Secret $secret

    echo $containerName + " configured"

   
}
