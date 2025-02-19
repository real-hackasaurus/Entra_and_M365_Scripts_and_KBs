<#
.SYNOPSIS
This script connects to the Exchange Online Management and syncs MIP labels.

.DESCRIPTION
The script imports the ExchangeOnlineManagement module, connects to the IPPS session using the provided UPN, and then executes the Azure AD label sync.

.INSTRUCTIONS
1. Ensure you have the necessary permissions to sync MIP labels.
2. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
3. Run the script using the provided examples or your own parameters.

.PERMISSIONS NEEDED
- Global Administrator
- Security Administrator (if required for certain actions)

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETERS
-UPN: User Principal Name (UPN) used to connect to the IPPS session.

.EXAMPLES
.\Sync-MIPLabels.ps1 -UPN user@contoso.com

.NOTES
Make sure to have the ExchangeOnlineManagement module installed and that you have the required permissions to execute the commands.
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
    # Import Exchange Online Management module
    Import-Module ExchangeOnlineManagement -ErrorAction Stop
} catch {
    Write-Error "Failed to import ExchangeOnlineManagement module: $_"
    exit 1
}

try {
    # Connect to IPPS session using the provided UPN
    Connect-IPPSSession -UserPrincipalName $UPN -ErrorAction Stop
} catch {
    Write-Error "Failed to connect to IPPS session: $_"
    exit 1
}

try {
    # Execute Azure AD label sync
    Execute-AzureAdLabelSync -ErrorAction Stop
    Write-Output "MIP labels synced successfully."
} catch {
    Write-Error "Failed to sync MIP labels: $_"
    exit 1
}