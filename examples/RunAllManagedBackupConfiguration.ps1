#Requires -Modules DBATools, SQLManagedBackup
function Invoke-Script
{
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Script,

        [Parameter(Mandatory = $false)]
        [object[]]
        $ArgumentList
    )

    $ScriptBlock = [Scriptblock]::Create((Get-Content $Script -Raw))
    Invoke-Command -NoNewScope -ArgumentList $ArgumentList -ScriptBlock $ScriptBlock -Verbose
}


$instances = Get-ChildItem -Path .\Config -Filter InstanceConfig.json
$configs = @()

$ags = Get-ChildItem -Path .\Config -Filter AGConfig.json
$agsConfigs = @()

foreach($instance in $instances) {
    [string]$configData = Get-Content -Path $instance.PSPath -Raw
    $configData | ConvertFrom-Json -OutVariable +configs | Out-Null
}

foreach($ag in $ags) {
    [string]$agConfigData = Get-Content -Path $ag.PSPath -Raw
    $agConfigData | ConvertFrom-Json -OutVariable +agsConfigs | Out-Null
}

echo "running instance configuration"
Invoke-Script -Script '..\SQLManagedBackup\deploy\SQLManagedBackup.ps1' -ArgumentList $configs -Verbose

echo "running availavility group configuration"
Invoke-Script -Script '..\SQLManagedBackup\deploy\SQLAGManagedBackup.ps1' -ArgumentList $agsConfigs -Verbose

