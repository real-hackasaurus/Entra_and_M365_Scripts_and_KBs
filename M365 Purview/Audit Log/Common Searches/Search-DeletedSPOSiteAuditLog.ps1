#TODO fields needed to run script, supplied as parameters
    #-Site URL
    #-Date time range, default to todays date if not supplied as a parameter

#TODO activity to look for
    #-"Deleted site" - record type is "SharePointFileOperation"

#TODO actions that script should perform
    #-take parameters
    #-search audit log
    #-export result to csv

<#
.SYNOPSIS
This script searches the Microsoft 365 Purview Audit Log for the deletion of a specified SharePoint site and exports the results to a CSV file.

.DESCRIPTION
This PowerShell script connects to Microsoft 365 Compliance Center, searches the audit log for events where a specified SharePoint site has been deleted within a given date range, and exports the findings to a CSV file. The user can specify a precise start and end date or a number of days back from the current date to search.

.PARAMETERS
- SiteUrl [Mandatory]: The URL of the SharePoint site to check for deletion events.
- StartDate [Optional]: The start date for the search range. Must be used with EndDate.
- EndDate [Optional]: The end date for the search range. Must be used with StartDate.
- DaysBack [Optional]: The number of days to search back from today's date. Cannot be used with StartDate or EndDate.

.EXAMPLE
PS> .\SPO_Site_Deleted.ps1 -SiteUrl "https://example.sharepoint.com/sites/sitename" -StartDate "2023-05-01" -EndDate "2023-05-17"

This example searches for deletion events for the specified SharePoint site between May 1, 2023, and May 17, 2023, and exports the results to a CSV file.

.EXAMPLE
PS> .\SPO_Site_Deleted.ps1 -SiteUrl "https://example.sharepoint.com/sites/sitename" -DaysBack 30

This example searches the past 30 days for deletion events of the specified SharePoint site and exports the results to a CSV file.

.NOTES
Author: Wes Blackwell
Last Updated: 5/17/2024
Version: 1.0
Required Modules: ExchangeOnlineManagement
Prerequisites: Administrative rights are required to connect to Microsoft 365 Compliance Center, and the appropriate permissions to access the audit log.

#>

param(
    [Parameter(Mandatory=$true)]
    [string]$SiteUrl,

    [Parameter(Mandatory=$false)]
    [datetime]$StartDate,

    [Parameter(Mandatory=$false)]
    [datetime]$EndDate,

    [Parameter(Mandatory=$false)]
    [int]$DaysBack
)


# Install the ExchangePowerShell module if it's not already installed
# Check if the ExchangePowerShell module is available
$module = Get-Module -ListAvailable -Name ExchangePowerShell

# If the module is not found, install it
if (-not $module) {
    Write-Host "ExchangePowerShell module is not installed. Installing now..."
    # Installing the ExchangePowerShell module
    Install-Module -Name ExchangePowerShell -Force
    Write-Host "ExchangePowerShell module installed successfully."
} else {
    Write-Host "ExchangePowerShell module is already installed."
}

# Import the module
Import-Module ExchangeOnlineManagement

# Connect to the Compliance Center
Connect-ExchangeOnline

# Determine the date range for the audit log search
if ($DaysBack) {
    $endDate = Get-Date
    $startDate = $endDate.AddDays(-$DaysBack)
} elseif ($StartDate -and $EndDate) {
    $startDate = $StartDate
    $endDate = $EndDate
} else {
    Write-Error "Either specify both StartDate and EndDate, or specify DaysBack."
    exit
}

# Search the audit log for SharePoint site deletion events
$searchResults = Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -RecordType SharePoint -Operations 'SiteDeleted' -ObjectIds $SiteUrl

# Export the results to a CSV file
$csvPath = "AuditLogResults.csv"
$searchResults | Export-Csv -Path $csvPath -NoTypeInformation

# Disconnect the session
Disconnect-ExchangeOnline