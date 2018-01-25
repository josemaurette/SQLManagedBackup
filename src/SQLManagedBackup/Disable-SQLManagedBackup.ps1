Function Disable-SQLManagedBackup {
    [cmdletbinding()]
    Param
    (
        [string] $ServerInstance,
	    [string] $Database
    )

    $query = @"
             USE msdb;
             IF EXISTS ( SELECT  *
             FROM    managed_backup.fn_backup_db_config('$Database') AS mb
             WHERE   mb.is_managed_backup_enabled = 1 )
             EXEC managed_backup.sp_backup_config_basic @database_name = '$Database', @enable_backup = 0;
"@;

    Invoke-Sqlcmd -ServerInstance $serverInstance -query $query -QueryTimeout 0
}