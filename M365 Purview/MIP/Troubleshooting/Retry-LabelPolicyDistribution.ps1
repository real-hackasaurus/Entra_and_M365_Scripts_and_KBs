<#
.SYNOPSIS
Sets a label policy in Exchange Online.

.DESCRIPTION
This script is designed to set a label policy in Exchange Online, specifically to retry distribution for a specified policy.

.INSTRUCTIONS
1. Ensure you have the necessary permissions to set label policies in Exchange Online.
2. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
3. Run the script using the provided examples or your own parameters.

.PERMISSIONS NEEDED
- Global Administrator
- Security Administrator (if required for certain actions)

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETERS
-UPN: User Principal Name required for connecting to Exchange Online.
-PolicyIdentity: Specifies the identity of the policy that you want to set.

.EXAMPLES
.\Retry-LabelPolicyDistribution.ps1 -UPN "user@yourdomain.com" -PolicyIdentity "Demo - Policy"

.NOTES
- Ensure the ExchangeOnlineManagement module is installed.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$UPN = $env:UPN,

    [Parameter(Mandatory=$true)]
    [string]$PolicyIdentity = $env:POLICY_IDENTITY
)

# Validate parameters
if (-not $UPN) {
    Write-Error "UPN parameter is required."
    exit 1
}
if (-not $PolicyIdentity) {
    Write-Error "PolicyIdentity parameter is required."
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
    # Import the ExchangeOnlineManagement module
    Import-Module ExchangeOnlineManagement -ErrorAction Stop
} catch {
    Write-Error "Failed to import ExchangeOnlineManagement module: $_"
    exit 1
}

try {
    # Connect to Exchange Online using the provided UPN
    Connect-ExchangeOnline -UserPrincipalName $UPN -ErrorAction Stop
} catch {
    Write-Error "Failed to connect to Exchange Online: $_"
    exit 1
}

try {
    # Set the label policy with the specified identity to retry distribution
    Set-LabelPolicy -RetryDistribution -Identity $PolicyIdentity -ErrorAction Stop
    Write-Output "Label policy '$PolicyIdentity' set for retry distribution."
} catch {
    Write-Error "Failed to set label policy for retry distribution: $_"
    exit 1
}