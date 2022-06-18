################################
#                              #
#  Documentation for Everyone  #
#                              #
################################

# Export documentation quickly
# Use for DR scenarios
# Use to monitor environment for changes

$instanceSplat = @{
    SqlInstance   = $dbatools1, $dbatools2
    Path          = '.\Export\'
    Exclude       = 'ReplicationSettings','CentralManagementServer'
}
Export-DbaInstance @instanceSplat

## Compare the sp_configure files