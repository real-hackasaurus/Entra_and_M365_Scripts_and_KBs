<#
.SYNOPSIS
Searches eDiscovery holds for specific SharePoint Online (SPO) sites.

.DESCRIPTION
This script retrieves the eDiscovery hold for a given name and then filters the SharePoint locations
to find sites that match the specified patterns.

.INSTRUCTIONS
1. Ensure you have the necessary permissions to access eDiscovery holds.
2. Ensure you are connected to the Security & Compliance Center (Connect-IPPSSession) before running.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
- eDiscovery Manager or eDiscovery Administrator

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETER HoldName
Specifies the name of the eDiscovery hold to search.

.PARAMETER SPOSearchPatterns
Specifies an array of search patterns for SPO sites.

.PARAMETER OutputFile
Specifies the path to the output file where the results will be saved.

.EXAMPLE
.\Search-eDiscoverySPOSites.ps1 -HoldName "HoldName123" -SPOSearchPatterns "*SPO-SITE1*", "*SPO-SITE2*" -OutputFile "C:\temp\results.txt"

.NOTES
File Name      : Search-eDiscoverySPOSites.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$HoldName,
    
    [Parameter(Mandatory=$true)]
    [string[]]$SPOSearchPatterns,

    [Parameter(Mandatory=$true)]
    [string]$OutputFile
)

# Retrieve the eDiscovery hold based on the specified identity
$Hold = Get-CaseHoldPolicy -Identity $HoldName -DistributionDetail
$SPO = $Hold.SharepointLocation

# Filter the SPO locations based on the specified search patterns
$Results = $SPO | Where-Object {
    $matched = $false
    foreach($pattern in $SPOSearchPatterns) {
        if ($_.Name -like $pattern) {
            $matched = $true
            break
        }
    }
    return $matched
} | Select-Object Name

# Output the results to the specified file
$Results | Out-File -Path $OutputFile

Write-Output "Results saved to $OutputFile"
