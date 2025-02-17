# Description:
# This script enables restricted access control for a SharePoint Online tenant.
# It connects to the SharePoint Online admin site and sets the tenant property to enable restricted access control.

# Instructions:
# 1. Ensure you have the SharePoint Online Management Shell module installed.
# 2. Replace the placeholder URL with your actual SharePoint Online admin site URL.
# 3. Run this script in PowerShell with appropriate permissions.

# Import the SharePoint Online Management Shell module
Import-Module Microsoft.Online.SharePoint.PowerShell

# Connect to SharePoint Online using modern authentication
$adminSiteURL = "https://your-admin-site-url.sharepoint.com/"
Connect-SPOService -Url $adminSiteURL

# Set the tenant property to enable restricted access control
Set-SPOTenant -EnableRestrictedAccessControl $true