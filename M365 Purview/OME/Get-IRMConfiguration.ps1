<#
.SYNOPSIS
This script displays the active IRM settings, useful for troubleshooting MIP.

.DESCRIPTION
The script imports the ExchangeOnlineManagement module, connects to Exchange Online, and retrieves the IRM configuration.

.INSTRUCTIONS
1. Ensure you have the necessary permissions to view the IRM configuration.
2. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
3. Run the script using the provided examples or your own parameters.

.PERMISSIONS NEEDED
- Global Admin (preferred)
- Compliance Admin (confirmed)
- Compliance Management, Hygiene Management, Organization Management, View-Only Organization Management

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETERS
-UPN: The User Principal Name (UPN) for administrative actions.

.EXAMPLES
.\Get-IRMConfiguration.ps1 -UPN "user@yourdomain.com"

.NOTES
- Ensure the ExchangeOnlineManagement module is installed.
- Cmdlets will be downloaded when the session is active.
- Security permissions need to be active first. If the user is not an admin, the command will fail to execute without giving a permission error.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$UPN = $env:UPN
)

# Validate parameters
if (-not $UPN) {
    Write-Error "UPN parameter is required."
    exit 1
}

# Check if ExchangeOnlineManagement module is installed
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    try {
        Install-Module -Name ExchangeOnlineManagement -Force -ErrorAction Stop
    } catch {
        Write-Error "Failed to install ExchangeOnlineManagement module: $_"
        exit 1
    }
}

try {
    # Import ExchangeOnlineManagement module
    Import-Module ExchangeOnlineManagement -ErrorAction Stop
} catch {
    Write-Error "Failed to import ExchangeOnlineManagement module: $_"
    exit 1
}

try {
    # Connect to Exchange Online
    Connect-ExchangeOnline -UserPrincipalName $UPN -ErrorAction Stop
} catch {
    Write-Error "Failed to connect to Exchange Online: $_"
    exit 1
}

try {
    # Get IRM Configuration
    $irmConfig = Get-IRMConfiguration -ErrorAction Stop
    Write-Output "IRM Configuration:"
    Write-Output $irmConfig | Format-List | Out-String
} catch {
    Write-Error "Failed to retrieve IRM Configuration: $_"
    exit 1
}