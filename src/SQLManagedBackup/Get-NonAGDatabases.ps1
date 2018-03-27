Function Get-NonAGDatabases {
    [cmdletbinding()]
    Param
    (
        [string] $ServerInstance
    )

    $query = @"
              SELECT  d.name as DatabaseName
              FROM    sys.databases d
              WHERE   d.replica_id IS NULL
              and d.name not in ('msdb','tempdb','model');
"@

    $result = Invoke-Sqlcmd -ServerInstance $serverInstance -query $query -QueryTimeout 0
    return $result
}

