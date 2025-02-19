<#
.SYNOPSIS
This script connects to the Azure Information Protection (AIP) service and retrieves filtered AIP admin logs based on provided criteria.

.DESCRIPTION
The script imports the AIPService module, establishes a connection to the AIP service, and retrieves AIP admin logs based on date range and specific text criteria.
Logs are saved to a specified path.

.INSTRUCTIONS
1. Ensure you have the necessary permissions to connect to the AIP service and retrieve logs.
2. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
3. Run the script using the provided examples or your own parameters.

.PERMISSIONS NEEDED
- Azure Information Protection Administrator
- Global Administrator (if required for certain actions)

.MODULES NEEDED
- AIPService

.PARAMETERS
-Path: The path where the AIP admin logs should be saved.
-StartDate: The starting date for the logs. Logs will be fetched from this date onwards.
-EndDate: The ending date for the logs. Logs will be fetched up to this date.
-FilterText: The specific text to filter the log entries. Only entries containing this text will be saved.

.EXAMPLES
.\GetAipAdminLogs.ps1 -Path "C:\MyDirectory\MyAdminLog.log" -StartDate "2023-01-01" -EndDate "2023-12-31" -FilterText "SuperUser"
.\GetAipAdminLogs.ps1 -Path "C:\MyDirectory\MyAdminLog.log" -FilterText "SuperUser"

.NOTES
- Ensure the AIPService module is installed.
- You should have the necessary permissions to connect to the AIP service and retrieve the logs.
- Make sure to run this script with elevated permissions if required.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$Path = $env:LOG_PATH,

    [datetime]$StartDate = [datetime]::Parse($env:START_DATE),
    [datetime]$EndDate = [datetime]::Parse($env:END_DATE),
    
    [string]$FilterText = $env:FILTER_TEXT
)

# Validate parameters
if (-not $Path) {
    Write-Error "Path parameter is required."
    exit 1
}

# Check if AIPService module is installed
if (-not (Get-Module -ListAvailable -Name AIPService)) {
    try {
        Install-Module -Name AIPService -Force -ErrorAction Stop
    } catch {
        Write-Error "Failed to install AIPService module: $_"
        exit 1
    }
}

try {
    # Import required module
    Import-Module AIPService -ErrorAction Stop
} catch {
    Write-Error "Failed to import AIPService module: $_"
    exit 1
}

try {
    # Connect to AIP Service
    Connect-AipService -ErrorAction Stop
} catch {
    Write-Error "Failed to connect to AIP service: $_"
    exit 1
}

try {
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
    $logs = Get-AipServiceAdminLog @params -ErrorAction Stop

    if ($FilterText) {
        $logs = $logs | Select-String -Pattern $FilterText
    }

    $logs | Out-File -Path $Path

    Write-Output "Logs have been saved to $Path"
} catch {
    Write-Error "Failed to retrieve or save AIP admin logs: $_"
    exit 1
}
