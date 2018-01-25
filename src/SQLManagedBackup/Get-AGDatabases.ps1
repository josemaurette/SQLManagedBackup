Function Get-AGDatabases {
    [cmdletbinding()]
    Param(
        [string] $ServerInstance,
        [string] $AvailabilityGroupName
    )

    $query = @"
    SELECT  adc.database_name DatabaseName
    FROM    sys.availability_groups AS ag
            JOIN sys.availability_databases_cluster AS adc ON adc.group_id = ag.group_id
    WHERE   ag.name = '$AvailabilityGroupName';
"@

    $result = Invoke-Sqlcmd -ServerInstance $serverInstance -query $query -QueryTimeout 0
    return $result
}
