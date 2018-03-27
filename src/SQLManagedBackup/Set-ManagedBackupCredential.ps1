Function Set-ManagedBackupCredential {
    [cmdletbinding()]
    Param
    (
        [string] $ServerInstance,
        [string] $Credential,
        [string] $Secret
    )

    $query = @"
              USE Master;
              if exists (
                         select *
                         from   sys.credentials s
                         where  s.name = '$Credential'
                        )
              begin
                 alter credential [$Credential]
                 with identity = 'SHARED ACCESS SIGNATURE'
                 ,secret = '$Secret';
              end
              else
              begin
              CREATE CREDENTIAL [$Credential]-- this name must match the container path, start with https and must not contain a forward slash.
              WITH IDENTITY='SHARED ACCESS SIGNATURE' -- this is a mandatory string and do not change it. 
              , SECRET = '$Secret'
              end
"@;

    Invoke-Sqlcmd -ServerInstance $serverInstance -query $query -QueryTimeout 0

}
