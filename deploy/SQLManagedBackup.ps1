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
    $EncryptionCertificate=$config.EncryptionCertificate
    $i = 0

    $results = Get-NonAGDatabases -ServerInstance $serverInstance 

    Write-Verbose  $serverInstance 


    $secret = Get-SharedAccessSignature -StorageAccountName $storageAccountName -AccountKey $accountKey -ContainerName $containerName -PolicyName $policyName
    Set-ManagedBackupCredential -ServerInstance $serverInstance -Credential $backupUrl -Secret $secret

    foreach ($result in $results)
    {
        $database = $result.DatabaseName

        if (($enableDatabases -match $database -or $enableDatabases -match "all") -and (-not($disableDatabases -match $database)))
        {
            $StaggeredHourResult = $StartHour.AddHours($i*$StaggeredHour).ToString("HH:mm")
            Enable-SQLManagedBackup -ServerInstance $serverInstance -Database $database -BackupUrl $backupUrl -Retention $retention -FullBackupFreqType $fullBackupFreqType -BackupBeginTime $StaggeredHourResult -LogBackupFreq $logBackupFreq -EncryptionCertificate $EncryptionCertificate
            $i+=1
        }
        else
        {
            Disable-SQLManagedBackup -ServerInstance $serverInstance -Database $database 
        }
        $dbConfigResults = Get-ManagedBackupConfig -ServerInstance $serverInstance -Database $database
        echo $dbConfigResults;
         
    }

   
}
