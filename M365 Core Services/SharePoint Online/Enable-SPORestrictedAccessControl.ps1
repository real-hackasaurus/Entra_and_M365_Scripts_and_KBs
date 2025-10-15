<#
.SYNOPSIS
This script enables restricted access control for a SharePoint Online tenant.

.DESCRIPTION
It connects to the SharePoint Online admin site and sets the tenant property to enable restricted access control.

.INSTRUCTIONS
1. Ensure you have the SharePoint Online Management Shell module installed.
2. Replace the placeholder URL with your actual SharePoint Online admin site URL.
3. Run this script in PowerShell with appropriate permissions.

.PERMISSIONS
You need to have sufficient permissions to modify tenant properties in SharePoint Online.

.MODULES NEEDED
- Microsoft.Online.SharePoint.PowerShell

.PARAMETER AdminSiteURL
The URL of the SharePoint Online admin site.

.EXAMPLE
.\Enable-SPORestrictedAccessControl.ps1 -AdminSiteURL "https://your-admin-site-url.sharepoint.com/"

This will enable restricted access control for the specified SharePoint Online tenant.

.NOTES
File Name      : Enable-SPORestrictedAccessControl.ps1
Author         : Wes Blackwell
Prerequisite   : Microsoft.Online.SharePoint.PowerShell Module
#>

# Description:
# This script enables restricted access control for a SharePoint Online tenant.
# It connects to the SharePoint Online admin site and sets the tenant property to enable restricted access control.

# Instructions:
# 1. Ensure you have the SharePoint Online Management Shell module installed.
# 2. Replace the placeholder URL with your actual SharePoint Online admin site URL.
# 3. Run this script in PowerShell with appropriate permissions.

param (
    [Parameter(Mandatory=$true)]
    [string]$AdminSiteURL = $env:ADMIN_SITE_URL
)

# Ensure parameters are not empty
try {
    if (-not $AdminSiteURL) {
        Write-Error "AdminSiteURL parameter is empty or not set!"
        exit
    }
} catch {
    Write-Error "Error checking AdminSiteURL parameter: $_"
    exit
}

# Import the SharePoint Online Management Shell module
try {
    Import-Module Microsoft.Online.SharePoint.PowerShell
} catch {
    Write-Error "Failed to import SharePoint Online Management Shell module: $_"
    exit
}

# Connect to SharePoint Online using modern authentication
try {
    Connect-SPOService -Url $AdminSiteURL
} catch {
    Write-Error "Failed to connect to SharePoint Online: $_"
    exit
}

# Set the tenant property to enable restricted access control
try {
    Set-SPOTenant -EnableRestrictedAccessControl $true
} catch {
    Write-Error "Failed to enable restricted access control: $_"
    exit
}