<#
.SYNOPSIS
This script exports all O365 Threat Protection rules (old ATP) from the portal and saves them in a CSV file.

.DESCRIPTION
Using the ExchangeOnlineManagement module, this script fetches all Safe Links policies and rules from the Security Portal and exports them to CSV files.

.INSTRUCTIONS
1. Ensure you have the ExchangeOnlineManagement module installed.
2. Connect to your Office 365 using the Connect-ExchangeOnline cmdlet.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
You need to have Global Admin or Security Admin permissions to see all policies and rules.

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETER AdminUserPrincipalName
The User Principal Name of the admin account to connect to Exchange Online.

.PARAMETER SafeLinksPolicyPath
The file path where the Safe Links policies CSV file will be saved.

.PARAMETER SafeLinksRulePath
The file path where the Safe Links rules CSV file will be saved.

.EXAMPLE
.\Export-SafeLinksPolicies.ps1 -AdminUserPrincipalName "youruser@domain.com" -SafeLinksPolicyPath "C:\Path\To\SafeLinksPolicy.csv" -SafeLinksRulePath "C:\Path\To\SafeLinksRule.csv"

This will export all Safe Links policies and rules to the specified CSV files.

.NOTES
File Name      : Export-SafeLinksPolicies.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$AdminUserPrincipalName = $env:ADMIN_USER_PRINCIPAL_NAME,

    [Parameter(Mandatory=$true)]
    [string]$SafeLinksPolicyPath = $env:SAFE_LINKS_POLICY_PATH,

    [Parameter(Mandatory=$true)]
    [string]$SafeLinksRulePath = $env:SAFE_LINKS_RULE_PATH
)

# Ensure parameters are not empty
try {
    if (-not $AdminUserPrincipalName) {
        Write-Error "AdminUserPrincipalName parameter is empty or not set!"
        exit
    }

    if (-not $SafeLinksPolicyPath) {
        Write-Error "SafeLinksPolicyPath parameter is empty or not set!"
        exit
    }

    if (-not $SafeLinksRulePath) {
        Write-Error "SafeLinksRulePath parameter is empty or not set!"
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

try {
    # Connect to Exchange Online
    Connect-ExchangeOnline -UserPrincipalName $AdminUserPrincipalName
} catch {
    Write-Error "Failed to connect to Exchange Online: $_"
    exit
}

try {
    # Export Safe Links Policies
    Get-SafeLinksPolicy | Export-Csv -Path $SafeLinksPolicyPath -NoTypeInformation
} catch {
    Write-Error "Error exporting Safe Links Policies: $_"
}

try {
    # Export Safe Links Rules
    Get-SafeLinksRule | Export-Csv -Path $SafeLinksRulePath -NoTypeInformation
} catch {
    Write-Error "Error exporting Safe Links Rules: $_"
}