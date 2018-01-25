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
        [string] $LogBackupFreq
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

    Invoke-Sqlcmd -ServerInstance $serverInstance -query $query -QueryTimeout 0

}