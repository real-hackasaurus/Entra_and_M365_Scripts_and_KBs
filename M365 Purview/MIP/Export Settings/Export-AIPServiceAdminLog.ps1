<#
.SYNOPSIS
This script exports all details of the AIP service admin log, including admin commands that have been run in PowerShell.

.DESCRIPTION
The script imports the AIPService module, connects to the AIP service, and exports the admin log to a specified path.

.INSTRUCTIONS
1. Ensure you have the necessary permissions to export the AIP service admin log.
2. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
3. Run the script using the provided examples or your own parameters.

.PERMISSIONS NEEDED
- Global Administrator (confirmed)

.MODULES NEEDED
- AIPService

.PARAMETERS
-Path: The path where the AIP admin logs should be saved.

.EXAMPLES
.\Export-AIPServiceAdminLog.ps1 -Path "C:\Temp\AdminLog.log"

.NOTES
- Ensure the AIPService module is installed.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$Path = $env:LOG_PATH
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
    # Import AIPService module
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
    # Export AIP admin log
    Get-AipServiceAdminLog -Path $Path -ErrorAction Stop
    Write-Output "AIP admin log has been successfully exported to $Path."
} catch {
    Write-Error "Failed to export AIP admin log: $_"
    exit 1
}