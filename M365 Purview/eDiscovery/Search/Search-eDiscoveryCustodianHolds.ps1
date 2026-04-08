<#
.SYNOPSIS
Searches eDiscovery holds by custodian hold ID.

.DESCRIPTION
This script retrieves the eDiscovery hold for a given custodian hold ID and outputs the related SharePoint locations.

.INSTRUCTIONS
1. Ensure you have the necessary permissions to access eDiscovery holds.
2. Ensure you are connected to the Security & Compliance Center (Connect-IPPSSession) before running.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
- eDiscovery Manager or eDiscovery Administrator

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETER CustodianHoldId
Specifies the ID of the custodian hold to search.

.PARAMETER OutputFile
Specifies the path to the output file where the results will be saved.

.EXAMPLE
.\Search-eDiscoveryCustodianHolds.ps1 -CustodianHoldId "CustodianHold-b627ef86afd64798-0638222667106043239" -OutputFile "C:\temp\custodianResults.txt"

.NOTES
File Name      : Search-eDiscoveryCustodianHolds.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$CustodianHoldId,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputFile
)

# Retrieve the eDiscovery hold based on the specified custodian hold ID
$Hold = Get-CaseHoldPolicy -Identity $CustodianHoldId -DistributionDetail

# Filter for SharePoint Locations
$SPO = $Hold.SharepointLocation

# Output the results to the specified file
$SPO | Select-Object Name | Out-File -Path $OutputFile

Write-Output "Results saved to $OutputFile"
