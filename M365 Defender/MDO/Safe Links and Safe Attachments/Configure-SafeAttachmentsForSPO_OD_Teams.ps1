<#
.SYNOPSIS
This script is designed to protect SharePoint Online (SPO), OneDrive (OD), and Teams with Safe Attachments and then verify the settings have taken place.

.DESCRIPTION
The script enables Safe Attachments for SharePoint Online, OneDrive, and Teams, prevents users from downloading malicious files, and creates an alert policy for detected files. It also verifies that the settings have been applied correctly.

.INSTRUCTIONS
1. Ensure you have the ExchangeOnlineManagement module installed.
2. Connect to your Office 365 using the Connect-ExchangeOnline cmdlet.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
You need to have Global Admin and SharePoint admin privileges.

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETER AdminUserPrincipalName
The User Principal Name of the admin account to connect to Exchange Online.

.PARAMETER SPOAdminUrl
The URL of the SharePoint Online admin site.

.PARAMETER NotifyUsers
A comma-separated list of users to notify when malicious files are detected.

.EXAMPLE
.\Configure-SafeAttachmentsForSPO_OD_Teams.ps1 -AdminUserPrincipalName "admin@contoso.onmicrosoft.com" -SPOAdminUrl "https://contoso-admin.sharepoint.com" -NotifyUsers "admin1@contoso.com,admin2@contoso.com"

This will configure Safe Attachments for SharePoint Online, OneDrive, and Teams, and set up notifications for the specified users.

.NOTES
File Name      : Configure-SafeAttachmentsForSPO_OD_Teams.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$AdminUserPrincipalName = $env:ADMIN_USER_PRINCIPAL_NAME,

    [Parameter(Mandatory=$true)]
    [string]$SPOAdminUrl = $env:SPO_ADMIN_URL,

    [Parameter(Mandatory=$true)]
    [string]$NotifyUsers = $env:NOTIFY_USERS
)

# Ensure parameters are not empty
try {
    if (-not $AdminUserPrincipalName) {
        Write-Error "AdminUserPrincipalName parameter is empty or not set!"
        exit
    }

    if (-not $SPOAdminUrl) {
        Write-Error "SPOAdminUrl parameter is empty or not set!"
        exit
    }

    if (-not $NotifyUsers) {
        Write-Error "NotifyUsers parameter is empty or not set!"
        exit
    }
} catch {
    Write-Error "Error checking parameters: $_"
    exit
}

Import-Module ExchangeOnlineManagement
Update-Module -Name Microsoft.Online.SharePoint.PowerShell

try {
    # Connect to Exchange Online
    Connect-ExchangeOnline -UserPrincipalName $AdminUserPrincipalName
} catch {
    Write-Error "Failed to connect to Exchange Online: $_"
    exit
}

try {
    # Step 1: Turn on Safe Attachments for SharePoint, OneDrive, and Microsoft Teams
    Set-AtpPolicyForO365 -EnableATPForSPOTeamsODB $true
} catch {
    Write-Error "Failed to enable Safe Attachments for SPO, OD, and Teams: $_"
}

try {
    # Step 2: Use SharePoint Online PowerShell to prevent users from downloading malicious files
    Connect-SPOService -Url $SPOAdminUrl
    Set-SPOTenant -DisallowInfectedFileDownload $true
} catch {
    Write-Error "Failed to set DisallowInfectedFileDownload: $_"
}

try {
    # Step 3: Create an alert policy for detected files
    New-ActivityAlert -Name "Malicious Files in Libraries" -Description "Notifies admins when malicious files are detected in SharePoint Online, OneDrive, or Microsoft Teams" -Category ThreatManagement -Operation FileMalwareDetected -NotifyUser $NotifyUsers
} catch {
    Write-Error "Failed to create alert policy: $_"
}

# Verify Settings are turned on
try {
    # Verify Step 1
    Get-AtpPolicyForO365 | Format-List EnableATPForSPOTeamsODB
} catch {
    Write-Error "Failed to verify Safe Attachments for SPO, OD, and Teams: $_"
}

try {
    # Verify Step 2
    Get-SPOTenant | Format-List DisallowInfectedFileDownload
} catch {
    Write-Error "Failed to verify DisallowInfectedFileDownload: $_"
}

try {
    # Verify Step 3
    Get-ActivityAlert -Identity "Malicious Files in Libraries"
} catch {
    Write-Error "Failed to verify alert policy: $_"
}