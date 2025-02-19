<#
.SYNOPSIS
This script exports the details of the current OME service configuration.

.DESCRIPTION
The script imports the ExchangeOnlineManagement module, connects to Exchange Online, and retrieves the OME service configuration.

.INSTRUCTIONS
1. Ensure you have the necessary permissions to export the OME service configuration.
2. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
3. Run the script using the provided examples or your own parameters.

.PERMISSIONS NEEDED
- Global Administrator (confirmed)

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETERS
-UPN: The User Principal Name (UPN) for administrative actions.

.EXAMPLES
.\Export-OMEServiceConfiguration.ps1 -UPN "yourname@domain.com"

.NOTES
- Ensure the ExchangeOnlineManagement module is installed.
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
    # Get OME Configuration
    $omeConfig = Get-OMEConfiguration -ErrorAction Stop
    Write-Output "OME Configuration:"
    Write-Output $omeConfig
} catch {
    Write-Error "Failed to retrieve OME Configuration: $_"
    exit 1
}