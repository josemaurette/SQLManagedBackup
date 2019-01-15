Function Get-AGServerInstances{
    [cmdletbinding()]
    Param(
        [string] $AvailabilityGroupAddress,
        [string] $AvailabilityGroupName

    )
    echo $AvailabilityGroupAddress
    $query = @"
              SELECT  ar.replica_server_name AS ServerInstance
              FROM    sys.availability_groups AS ag
                  JOIN sys.availability_replicas AS ar ON ar.group_id = ag.group_id
                  JOIN sys.dm_hadr_availability_replica_states AS s
                                          ON s.group_id = ag.group_id
                                          AND s.replica_id = ar.replica_id
                                
              WHERE   ag.name = '$AvailabilityGroupName'
              ORDER BY s.role;
"@

    $result = Invoke-Sqlcmd -ServerInstance $AvailabilityGroupAddress -query $query -QueryTimeout 0
    return $result
}
