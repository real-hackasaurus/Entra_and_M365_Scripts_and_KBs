<#
.SYNOPSIS
This script exports all O365 Threat Protection rules (old ATP) from the portal and saves them in a CSV file.

.DESCRIPTION
Using the ExchangeOnlineManagement module, this script fetches all Safe Attachment policies and rules from the Security Portal and exports them to CSV files.

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

.PARAMETER SafeAttachmentPolicyPath
The file path where the Safe Attachment policies CSV file will be saved.

.PARAMETER SafeAttachmentRulePath
The file path where the Safe Attachment rules CSV file will be saved.

.EXAMPLE
.\Export-SafeAttachmentsPolicies.ps1 -AdminUserPrincipalName "youruser@domain.com" -SafeAttachmentPolicyPath "C:\Path\To\SafeAttachmentPolicy.csv" -SafeAttachmentRulePath "C:\Path\To\SafeAttachmentRule.csv"

This will export all Safe Attachment policies and rules to the specified CSV files.

.NOTES
File Name      : Export-SafeAttachmentsPolicies.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$AdminUserPrincipalName = $env:ADMIN_USER_PRINCIPAL_NAME,

    [Parameter(Mandatory=$true)]
    [string]$SafeAttachmentPolicyPath = $env:SAFE_ATTACHMENT_POLICY_PATH,

    [Parameter(Mandatory=$true)]
    [string]$SafeAttachmentRulePath = $env:SAFE_ATTACHMENT_RULE_PATH
)

# Ensure parameters are not empty
try {
    if (-not $AdminUserPrincipalName) {
        Write-Error "AdminUserPrincipalName parameter is empty or not set!"
        exit
    }

    if (-not $SafeAttachmentPolicyPath) {
        Write-Error "SafeAttachmentPolicyPath parameter is empty or not set!"
        exit
    }

    if (-not $SafeAttachmentRulePath) {
        Write-Error "SafeAttachmentRulePath parameter is empty or not set!"
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
    # Export Safe Attachment Policies
    Get-SafeAttachmentPolicy | Export-Csv -Path $SafeAttachmentPolicyPath -NoTypeInformation
} catch {
    Write-Error "Error exporting Safe Attachment Policies: $_"
}

try {
    # Export Safe Attachment Rules
    Get-SafeAttachmentRule | Export-Csv -Path $SafeAttachmentRulePath -NoTypeInformation
} catch {
    Write-Error "Error exporting Safe Attachment Rules: $_"
}