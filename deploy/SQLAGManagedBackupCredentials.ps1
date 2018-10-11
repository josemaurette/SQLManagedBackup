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
    $storageAccountName = $agConfig.StorageAccountName
    $accountKey = $agConfig.AccountKey
    $containerName = $agConfig.ContainerName
    $policyName = $agConfig.PolicyName
    $retention = $agConfig.DefaultRetention
    $FullBackupFreqType = $agConfig.DefaultFullBackupFreqType
    $backupBeginTime = $agConfig.DefaultBackupBeginTime
    $logBackupFreq = $agConfig.DefaultLogBackupFreq
    $StaggeredHour=$agConfig.StaggeredIntervalHour
    $StartHour =  [datetime]$backupBeginTime
    $i = 0

    $serverInstanceses = Get-AGServerInstances -AvailabilityGroupAddress $availabilityGroupAddress -AvailabilityGroupName $availabilityGroupName
    
        $serverInstanceses = Get-AGServerInstances -AvailabilityGroupAddress $availabilityGroupAddress -AvailabilityGroupName $availabilityGroupName
    
    foreach ($si in $serverInstanceses)
    {
        $serverInstance = $si.ServerInstance
        echo $serverInstance
        Write-Verbose  $serverInstance 
        $secret = Get-SharedAccessSignature -StorageAccountName $storageAccountName -AccountKey $accountKey -ContainerName $containerName -PolicyName $policyName

        Set-ManagedBackupCredential -ServerInstance $serverInstance -Credential $backupUrl -Secret $secret
        
    }
    echo $containerName + " configured"

   
}
