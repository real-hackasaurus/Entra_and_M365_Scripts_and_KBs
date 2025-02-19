<#
.SYNOPSIS
This script exports all O365 Threat Protection rules (old ATP) from the portal and saves them in a CSV file.

.DESCRIPTION
Using the ExchangeOnlineManagement module, this script fetches all global configurations for Safe Attachments and Safe Links and exports them to a CSV file.

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

.PARAMETER OutputPath
The file path where the CSV file will be saved.

.EXAMPLE
.\Export-O365ThreatProtectionPolicies.ps1 -AdminUserPrincipalName "youruser@domain.com" -OutputPath "C:\Path\To\AtpPolicyForO365.csv"

This will export all global configurations for Safe Attachments and Safe Links to the specified CSV file.

.NOTES
File Name      : Export-O365ThreatProtectionPolicies.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$AdminUserPrincipalName = $env:ADMIN_USER_PRINCIPAL_NAME,

    [Parameter(Mandatory=$true)]
    [string]$OutputPath = $env:OUTPUT_PATH
)

# Ensure parameters are not empty
try {
    if (-not $AdminUserPrincipalName) {
        Write-Error "AdminUserPrincipalName parameter is empty or not set!"
        exit
    }

    if (-not $OutputPath) {
        Write-Error "OutputPath parameter is empty or not set!"
        exit
    }
} catch {
    Write-Error "Error checking parameters: $_"
    exit
}

Import-Module ExchangeOnlineManagement

try {
    # Connect to Exchange Online
    Connect-ExchangeOnline -UserPrincipalName $AdminUserPrincipalName
} catch {
    Write-Error "Failed to connect to Exchange Online: $_"
    exit
}

try {
    # Export ATP Policies
    Get-AtpPolicyForO365 | Export-Csv -Path $OutputPath -NoTypeInformation
} catch {
    Write-Error "Error exporting ATP Policies: $_"
}