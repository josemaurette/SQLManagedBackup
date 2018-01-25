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
    $retention = $config.DefaultRetention
    $FullBackupFreqType = $config.DefaultFullBackupFreqType
    $backupBeginTime = $config.DefaultBackupBeginTime
    $logBackupFreq = $config.DefaultLogBackupFreq

    $results = Get-NonAGDatabases -ServerInstance $serverInstance 

    Write-Verbose  $serverInstance 
    foreach ($result in $results)
    {
        $database = $result.DatabaseName

        if (($enableDatabases -match $database -or $enableDatabases -match "all") -and (-not($disableDatabases -match $database)))
        {
            Enable-SQLManagedBackup -ServerInstance $serverInstance -Database $database -BackupUrl $backupUrl -Retention $retention -FullBackupFreqType $fullBackupFreqType -BackupBeginTime $backupBeginTime -LogBackupFreq $logBackupFreq
        }
        else
        {
            Disable-SQLManagedBackup -ServerInstance $serverInstance -Database $database 
        }
        $dbConfigResults = Get-ManagedBackupConfig -ServerInstance $serverInstance -Database $database
        echo $dbConfigResults;
         
    }

   
}
