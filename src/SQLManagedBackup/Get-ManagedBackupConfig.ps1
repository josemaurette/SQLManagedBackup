Function Get-ManagedBackupConfig {
    [cmdletbinding()]
    Param(
        [string] $ServerInstance,
	    [string] $Database
    )

    $query = @"
              USE msdb;

              SELECT mc.db_name DatabaseName,
                     mc.is_availability_database HighlyAvailable ,
                     mc.is_managed_backup_enabled ManagedBackupEnabled,
                     mc.container_url ContainerUrl,
                     mc.retention_days RetentionDays,
                     mc.full_backup_freq_type FullBackupFrequencyType ,
                     mc.log_backup_freq LogBackupFrequency
              FROM   managed_backup.fn_backup_db_config('$Database') AS mc;
"@

    $result = Invoke-Sqlcmd -ServerInstance $serverInstance -query $query -QueryTimeout 0
    return $result
}
