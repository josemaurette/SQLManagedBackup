$sourceRoot = (get-item -path ".\" -Verbose).Parent.Fullname
$currentFolder = $PSScriptRoot

Set-Location $sourceRoot

Set-Location .\SQLManagedBackup

Import-Module .\src\SQLManagedBackup\SQLManagedBackup.psm1 -Force -Verbose


Set-Location $currentFolder
