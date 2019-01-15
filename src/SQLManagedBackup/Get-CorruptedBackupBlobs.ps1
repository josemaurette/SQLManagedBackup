Function Get-CorruptedBackupBlobs {
    [cmdletbinding()]
    Param
    (
        [string] $ServerInstance
    )

    $query = "sys.xp_readerrorlog 0,1,N'read failure on backup device'"

    $blobBackupErrorErrorList = Invoke-Sqlcmd -ServerInstance $ServerInstance -Query "sys.xp_readerrorlog 0,1,N'read failure on backup device'";

    $distinctblobBackupErrorList = @();

    foreach ($blobBackupError in $blobBackupErrorErrorList)
    { 
        $IndexofContainerStart = $blobBackupError.Text.IndexOf('.net/') + 5
        $IndexofBlobEnd = $blobBackupError.Text.IndexOf('. Operating system error') - 1
        $blobandContainer = $blobBackupError.Text.Substring($IndexofContainerStart,$IndexofBlobEnd - $IndexofContainerStart)
        If ($distinctblobBackupErrorList -notcontains $blobandContainer)
          {
            $distinctblobBackupErrorList += $blobandContainer
          }
     }

    $blobsAndContainersArray = @()
    
    foreach ( $DistinctblobBackup in $distinctblobBackupErrorList )
    {
        $container = $DistinctblobBackup.Substring(0,$DistinctblobBackup.IndexOf('/'))
        $blob = $DistinctblobBackup.Substring($DistinctblobBackup.IndexOf('/') +1,$DistinctblobBackup.length - $DistinctblobBackup.IndexOf('/') -1)
        
        $blobAndContainerobject = New-Object -TypeName PSObject
        $blobAndContainerObject | Add-Member -Name 'Container' -MemberType Noteproperty -Value $container
        $blobAndContainerObject | Add-Member -Name 'Blob' -MemberType Noteproperty -Value $blob
        $blobsAndContainersArray += $blobAndContainerObject
    
    }

	return $blobsAndContainersArray
}