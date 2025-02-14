<#
.SYNOPSIS
Searches eDiscovery holds for specific SharePoint Online (SPO) sites.

.DESCRIPTION
This script retrieves the eDiscovery hold for a given name and then filters the SharePoint locations 
to find sites that match the specified patterns.

.PARAMETER HoldName
Specifies the name of the eDiscovery hold to search.

.PARAMETER SPOSearchPatterns
Specifies an array of search patterns for SPO sites.

.PARAMETER OutputFile
Specifies the path to the output file where the results will be saved.

.EXAMPLE
.\Search_eDiscovery_SPO_Sites.ps1 -HoldName "HoldName123" -SPOSearchPatterns "*SPO-SITE1*", "*SPO-SITE2*" -OutputFile "C:\temp\results.txt"

.NOTES
Ensure the required modules are installed and you are authenticated to the services before executing the script.
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
