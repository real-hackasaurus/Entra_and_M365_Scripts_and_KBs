<#
.SYNOPSIS
Removes specified SharePoint locations from an eDiscovery hold.

.DESCRIPTION
This script removes SharePoint locations (based on provided URLs) from an eDiscovery hold with a given name.

.PARAMETER HoldName
Specifies the name of the eDiscovery hold from which SharePoint locations are to be removed.

.PARAMETER SharePointURLs
Specifies an array of SharePoint URLs to remove from the eDiscovery hold.

.EXAMPLE
.\Remove_SPO_From_eDiscovery_Hold.ps1 -HoldName "HoldName123" -SharePointURLs "https://example.com/spo1", "https://example.com/spo2"

.NOTES
Ensure the required modules are installed and you are authenticated to the services before executing the script.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$HoldName,
    
    [Parameter(Mandatory=$true)]
    [string[]]$SharePointURLs
)

# Remove the specified SharePoint locations from the eDiscovery hold
Set-CaseHoldPolicy -Identity $HoldName -RemoveSharePointLocation $SharePointURLs

Write-Output "Removed specified SharePoint locations from $HoldName."
