<#
.SYNOPSIS
This script connects to the Azure Information Protection (AIP) service and retrieves filtered AIP admin logs based on provided criteria.

.DESCRIPTION
The script imports the AIPService module, establishes a connection to the AIP service, and retrieves AIP admin logs based on date range and specific text criteria.
Logs are saved to a specified path.

.PARAMETER Path
The path where the AIP admin logs should be saved.

.PARAMETER StartDate
The starting date for the logs. Logs will be fetched from this date onwards.

.PARAMETER EndDate
The ending date for the logs. Logs will be fetched up to this date.

.PARAMETER FilterText
The specific text to filter the log entries. Only entries containing this text will be saved.

.EXAMPLE
.\GetAipAdminLogs.ps1 -Path "C:\MyDirectory\MyAdminLog.log" -StartDate "2023-01-01" -EndDate "2023-12-31" -FilterText "SuperUser"

This will save the AIP admin logs for the year 2023 containing the text "SuperUser" to "C:\MyDirectory\MyAdminLog.log".

.NOTES
- Ensure the AIPService module is installed.
- You should have the necessary permissions to connect to the AIP service and retrieve the logs.
- Make sure to run this script with elevated permissions if required.

#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path,

    [datetime]$StartDate,
    [datetime]$EndDate,
    
    [string]$FilterText
)

# Import required module
Import-Module AIPService

# Connect to AIP Service
Connect-AipService

# Create a hashtable for splatting parameters dynamically
$params = @{
    Path = $null
}

if ($StartDate) {
    $params['StartDate'] = $StartDate
}

if ($EndDate) {
    $params['EndDate'] = $EndDate
}

# Get AIP Admin logs and filter based on specified text
$logs = Get-AipServiceAdminLog @params

if ($FilterText) {
    $logs = $logs | Select-String -Pattern $FilterText
}

$logs | Out-File -Path $Path

Write-Output "Logs have been saved to $Path"
