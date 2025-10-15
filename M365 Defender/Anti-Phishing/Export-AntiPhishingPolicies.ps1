<#
.SYNOPSIS
This script exports all O365 Threat Protection rules (old ATP) from the portal and saves them in a CSV file.

.DESCRIPTION
Using the ExchangeOnlineManagement module, this script fetches all Safe Links policies, Safe Links rules, Safe Attachment policies, Safe Attachment rules, ATP policies, and Anti-Phish policies from the Security Portal and exports them to CSV files.

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

.PARAMETER AntiPhishPolicyPath
The file path where the Anti-Phish policies CSV file will be saved.

.PARAMETER AntiPhishRulePath
The file path where the Anti-Phish rules CSV file will be saved.

.EXAMPLE
.\Export-AntiPhishingPolicies.ps1 -AdminUserPrincipalName "youruser@domain.com" -AntiPhishPolicyPath "C:\Path\To\AntiPhishPolicy.csv" -AntiPhishRulePath "C:\Path\To\AntiPhishRule.csv"

This will export all Anti-Phish policies and rules to the specified CSV files.

.NOTES
File Name      : Export-AntiPhishingPolicies.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

<#

    -Created by: Wesley Blackwell
    -Date last updated: 5/3/2022

    -Overview:
        This script is designed to export all O365 Threat Protection rules (old atp) from the portal and put them in a csv.
    -Overview doc, Get-SafeLinksPolicy: https://docs.microsoft.com/en-us/powershell/module/exchange/get-safelinkspolicy?view=exchange-ps
    -Overview doc, Get-SafeLinksRule: https://docs.microsoft.com/en-us/powershell/module/exchange/get-safelinksrule?view=exchange-ps
    -Overview doc, Get-SafeAttachmentPolicy: https://docs.microsoft.com/en-us/powershell/module/exchange/get-safeattachmentpolicy?view=exchange-ps
    -Overview doc, Get-SafeAttachmentRule: https://docs.microsoft.com/en-us/powershell/module/exchange/get-safeattachmentrule?view=exchange-ps
    -Overview doc, Get-AtpPolicyForO365: https://docs.microsoft.com/en-us/powershell/module/exchange/get-atppolicyforo365?view=exchange-ps
    -Overview doc, Get-AntiPhishPolicy: https://docs.microsoft.com/en-us/powershell/module/exchange/get-antiphishpolicy?view=exchange-ps

    -Permissions Needed:
        -Global Admin (confirmed): Preferred since this user can see everything. 
        -Security admin: All cmdlets

    -Modules Needed:
        -ExchangeOnlineManagement

    -Notes:
        -Cmdlets will be downloaded when the session is active.
        -Security permissions need to be active first. If user is not an admin, the command will just fail to execute without giving a permission error.
        -Save and run in local runspace so files save where you want them to.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$AdminUserPrincipalName = $env:ADMIN_USER_PRINCIPAL_NAME,

    [Parameter(Mandatory=$true)]
    [string]$AntiPhishPolicyPath = $env:ANTI_PHISH_POLICY_PATH,

    [Parameter(Mandatory=$true)]
    [string]$AntiPhishRulePath = $env:ANTI_PHISH_RULE_PATH
)

# Ensure parameters are not empty
try {
    if (-not $AdminUserPrincipalName) {
        Write-Error "AdminUserPrincipalName parameter is empty or not set!"
        exit
    }

    if (-not $AntiPhishPolicyPath) {
        Write-Error "AntiPhishPolicyPath parameter is empty or not set!"
        exit
    }

    if (-not $AntiPhishRulePath) {
        Write-Error "AntiPhishRulePath parameter is empty or not set!"
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
    # Export Anti-Phish Policies
    Get-AntiPhishPolicy | Export-Csv -Path $AntiPhishPolicyPath -NoTypeInformation
} catch {
    Write-Error "Error exporting Anti-Phish Policies: $_"
}

try {
    # Export Anti-Phish Rules
    Get-AntiPhishRule | Export-Csv -Path $AntiPhishRulePath -NoTypeInformation
} catch {
    Write-Error "Error exporting Anti-Phish Rules: $_"
}