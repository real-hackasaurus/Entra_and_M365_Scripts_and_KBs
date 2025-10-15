<#
.SYNOPSIS
Removes specified SharePoint locations from an eDiscovery hold.

.DESCRIPTION
This script removes SharePoint locations (based on provided URLs) from an eDiscovery hold with a given name.

.INSTRUCTIONS
1. Ensure you have the necessary modules installed.
2. Connect to your Office 365 using the appropriate cmdlets.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
You need to have sufficient permissions to manage eDiscovery holds in Office 365.

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETER HoldName
Specifies the name of the eDiscovery hold from which SharePoint locations are to be removed.

.PARAMETER SharePointURLs
Specifies an array of SharePoint URLs to remove from the eDiscovery hold.

.EXAMPLE
.\Remove-SPOFromeDiscoveryHold.ps1 -HoldName "HoldName123" -SharePointURLs "https://example.com/spo1", "https://example.com/spo2"

This will remove the specified SharePoint locations from the eDiscovery hold named "HoldName123".

.NOTES
File Name      : Remove-SPOFromeDiscoveryHold.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$HoldName = $env:HOLD_NAME,
    
    [Parameter(Mandatory=$true)]
    [string[]]$SharePointURLs = $env:SHAREPOINT_URLS -split ","
)

# Ensure parameters are not empty
try {
    if (-not $HoldName) {
        Write-Error "HoldName parameter is empty or not set!"
        exit
    }

    if (-not $SharePointURLs) {
        Write-Error "SharePointURLs parameter is empty or not set!"
        exit
    }
} catch {
    Write-Error "Error checking parameters: $_"
    exit
}

# Check if the ExchangeOnlineManagement module is installed and imported
try {
    if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
        Install-Module -Name ExchangeOnlineManagement -Force
    }
    Import-Module ExchangeOnlineManagement
} catch {
    Write-Error "Failed to install or import ExchangeOnlineManagement module: $_"
    exit
}

# Connect to Exchange Online
try {
    Connect-IPPSSession -UserPrincipalName $env:USER_PRINCIPAL_NAME
} catch {
    Write-Error "Failed to connect to Exchange Online: $_"
    exit
}

# Remove the specified SharePoint locations from the eDiscovery hold
try {
    Set-CaseHoldPolicy -Identity $HoldName -RemoveSharePointLocation $SharePointURLs
    Write-Output "Removed specified SharePoint locations from $HoldName."
} catch {
    Write-Error "Error removing SharePoint locations from eDiscovery hold: $_"
}
