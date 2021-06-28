Function Enable-SQLManagedBackup {
    [cmdletbinding()]
    Param
    (
        [string] $ServerInstance,
        [string] $Database,
        [string] $BackupUrl,
        [int]    $Retention,
        [string] $FullBackupFreqType,
        [string] $BackupBeginTime,
        [string] $LogBackupFreq,
        [string] $EncryptionCertificate
    )

    $query = @"
              USE msdb;
              EXEC managed_backup.sp_backup_config_basic @database_name = '$Database',
              @enable_backup = 1, 
              @container_url = N'$BackupUrl',
              @retention_days = $Retention;
              
              USE msdb;
              EXEC managed_backup.sp_backup_config_schedule @database_name = '$Database',
              @scheduling_option = 'Custom',
              @full_backup_freq_type = '$FullBackupFreqType',
              @backup_begin_time = N'$BackupBeginTime',
              @backup_duration = N'04:00',
              @log_backup_freq = N'$LogBackupFreq'
"@;

    #Add encryption if set in config
    if ($EncryptionCertificate) {
        
        #Dont encrypt master and other system DBs
        if ($Database -notin @("master", "model", "tempdb")) {
            $query += @"
        
            USE msdb;
            EXEC managed_backup.sp_backup_config_advanced  @database_name = '$Database'                
            ,@encryption_algorithm ='AES_256'  
            ,@encryptor_type = 'CERTIFICATE'  
            ,@encryptor_name = '$EncryptionCertificate';  
"@;
        }
    } 

    Invoke-Sqlcmd -ServerInstance $serverInstance -query $query -QueryTimeout 0

}