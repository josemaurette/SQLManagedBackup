[cmdletbinding()]
Param
(
    $agsConfigs
)


foreach($agConfig in $agsConfigs) 
{
    $availabilityGroupAddress = $agConfig.AvailabilityGroupAddress
    $availabilityGroupName = $agConfig.AvailabilityGroupName
    $enableDatabases = $agConfig.EnableDatabases
    $disableDatabases = $agConfig.DisableDatabases
    $backupUrl = $agConfig.BackupUrl
    $retention = $agConfig.DefaultRetention
    $FullBackupFreqType = $agConfig.DefaultFullBackupFreqType
    $backupBeginTime = $agConfig.DefaultBackupBeginTime
    $logBackupFreq = $agConfig.DefaultLogBackupFreq

    $serverInstanceses = Get-AGServerInstances -AvailabilityGroupAddress $availabilityGroupAddress -AvailabilityGroupName $availabilityGroupName
    
    foreach ($si in $serverInstanceses)
    {
        $serverInstance = $si.ServerInstance
        $results = Get-AGDatabases -ServerInstance $serverInstance -AvailabilityGroupName $availabilityGroupName

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
        echo $dbConfigResults
         
        }
        
    }

   
}
