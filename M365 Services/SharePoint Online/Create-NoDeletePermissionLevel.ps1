<#
    -Created by: Wesley Blackwell
    -Date last updated: 2/14/2025

    -Overview:
        This script creates a custom permission level in SharePoint Online that excludes delete permissions and assigns it to the site owners group.
        The custom permission level is cloned from the "Full Control" permission level but excludes the ability to delete list items and versions.

    -Instructions:
        1. Ensure you have the PnP.PowerShell module installed.
        2. Update the $SiteURL variable with the URL of your SharePoint site.
        3. Update the $CustomRoleName variable with the desired name for the custom permission level.
        4. Run the script in PowerShell.
        5. The script will connect to the specified SharePoint site, create the custom permission level, and assign it to the site owners group.

    -Permissions Needed:
        - SharePoint Admin or Site Collection Admin

    -Modules Needed:
        - PnP.PowerShell

    -Notes:
        - Ensure you have the necessary permissions to create and assign permission levels in SharePoint Online.
#>

# Set Variables
$SiteURL = "https://your-sharepoint-site-url"  # Change this URL to your SharePoint site URL
$CustomRoleName = "Full Control No Delete"     # Change this role name as needed

# Import required module
Import-Module -Name "PnP.PowerShell"

# Connect to PnP Online
Connect-PnPOnline -UseWebLogin -Url $SiteURL

# Get Permission level to copy
$fullControlRole = Get-PnPRoleDefinition -Identity "Full Control"

# Create a custom Permission level and exclude delete from contribute 
Add-PnPRoleDefinition -RoleName $CustomRoleName -Clone $fullControlRole -Exclude DeleteListItems, DeleteVersions -Description $CustomRoleName

# Get the Owner Group of the site
$ownerGroup = Get-PnPSiteGroup | Where-Object { $_.Title -like "*Owners" }

if ($ownerGroup -ne $null) {
    # Get the role definition for the custom permission level
    $customRole = Get-PnPRoleDefinition -Identity $CustomRoleName

    if ($customRole -ne $null) {
        # Assign the custom permission level to the Owner Group
        Set-PnPSiteGroup -Site $SiteURL -Identity $ownerGroup.Title -PermissionLevelsToRemove "Full Control" -PermissionLevelsToAdd $customRole.Name
        Write-Host "Successfully updated the permission level for the Owner group to $CustomRoleName"
    } else {
        Write-Host "Custom permission level '$CustomRoleName' not found"
    }
} else {
    Write-Host "Owner group not found"
}

# Disconnect the PnP Online session
Disconnect-PnPOnline