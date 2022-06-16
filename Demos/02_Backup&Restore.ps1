#######################
#                     #
#  Test Your Backups  #
#                     #
#######################

# Review backup history
# Backup your databases
# Test those backups
# Your backups are useless if they can't be restored
# Save restore testing results to a table
# A DISASTER STRIKES

## Get the backup history for the mssql1 server
$instanceSplat = @{
    SqlInstance = $dbatools1
}
Get-DbaDbBackupHistory @instanceSplat | Sort-Object Start

## Backup all the databases
$backupParams = @{
    SqlInstance = $dbatools1
}
Backup-DbaDatabase @backupParams

## Backup all the databases - Log backup
$backupParams = @{
    SqlInstance = $dbatools1
    Type        = 'Log'
}
Backup-DbaDatabase @backupParams

#####################
# BUT DO THEY WORK? #
#####################

## Offload testing your backups to a second server
$testParams = @{
    SqlInstance = $dbatools1
    Destination = $dbatools2
    #Verbose     = $true
    OutVariable = 'results'
}
Test-DbaLastBackup @testParams

## Record your backup tests into a SQL Server table
$writeParams = @{
    SqlInstance     = $dbatools1
    Database        = 'DatabaseAdmin'
    Table           = 'TestRestore'
    AutoCreateTable = $true
}
$results | Write-DbaDataTable @writeParams

## Using Piping
Test-DbaLastBackup @testParams | Write-DbaDataTable @writeParams

#######################
# TIME FOR A DISASTER #
#######################

## Let's check on our databases
$instanceSplat = @{
    SqlInstance = $dbatools1
}
Get-DbaDatabase @instanceSplat -ExcludeSystem | Format-Table

## What if some uncaffinated person runs this?
Get-DbaDatabase @instanceSplat -ExcludeSystem | Remove-DbaDatabase -Confirm:$false

## Databases? where are you?
Get-DbaDatabase @instanceSplat -ExcludeSystem | Format-Table

## Let's view the files in our backup share
$restoreSplat = @{
    SqlInstance = $dbatools1
    Path = '/shared'
}
Get-DbaFile @restoreSplat

## With one line we can get them all back - to the last backup we took.
Restore-DbaDatabase @restoreSplat

## Phew
Get-DbaDatabase @instanceSplat -ExcludeSystem | Format-Table