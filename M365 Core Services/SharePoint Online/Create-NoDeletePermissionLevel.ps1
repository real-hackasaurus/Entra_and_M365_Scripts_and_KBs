<#
.SYNOPSIS
This script creates a custom permission level in SharePoint Online that excludes delete permissions and assigns it to the site owners group.

.DESCRIPTION
The custom permission level is cloned from the "Full Control" permission level but excludes the ability to delete list items and versions.

.INSTRUCTIONS
1. Ensure you have the PnP.PowerShell module installed.
2. Update the $SiteURL variable with the URL of your SharePoint site.
3. Update the $CustomRoleName variable with the desired name for the custom permission level.
4. Run the script in PowerShell.
5. The script will connect to the specified SharePoint site, create the custom permission level, and assign it to the site owners group.

.PERMISSIONS
You need to have SharePoint Admin or Site Collection Admin permissions.

.MODULES NEEDED
- PnP.PowerShell

.PARAMETER SiteURL
The URL of the SharePoint site where the custom permission level will be created.

.EXAMPLE
.\Create-NoDeletePermissionLevel.ps1 -SiteURL "https://your-sharepoint-site-url"

This will create a custom permission level named "Full Control No Delete" in the specified SharePoint site and assign it to the site owners group.

.NOTES
File Name      : Create-NoDeletePermissionLevel.ps1
Author         : Wes Blackwell
Prerequisite   : PnP.PowerShell Module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$SiteURL = $env:SITE_URL
)

# Ensure parameters are not empty
if (-not $SiteURL) {
    Write-Error "SiteURL parameter is empty or not set!"
    exit
}

# Set Variables
$CustomRoleName = "Full Control No Delete"     # Change this role name as needed

# Import required module
Import-Module -Name "PnP.PowerShell"

# Connect to PnP Online
try {
    Connect-PnPOnline -UseWebLogin -Url $SiteURL
} catch {
    Write-Error "Failed to connect to PnP Online: $_"
    exit
}

try {
    # Get Permission level to copy
    $fullControlRole = Get-PnPRoleDefinition -Identity "Full Control"

    # Create a custom Permission level and exclude delete from contribute 
    Add-PnPRoleDefinition -RoleName $CustomRoleName -Clone $fullControlRole -Exclude DeleteListItems, DeleteVersions -Description $CustomRoleName

    # Get the Owner Group of the site
    $ownerGroup = Get-PnPSiteGroup | Where-Object { $_.Title -like "*Owners" }

    if ($ownerGroup -ne $null) {
        try {
            # Get the role definition for the custom permission level
            $customRole = Get-PnPRoleDefinition -Identity $CustomRoleName

            if ($customRole -ne $null) {
                # Assign the custom permission level to the Owner Group
                Set-PnPSiteGroup -Site $SiteURL -Identity $ownerGroup.Title -PermissionLevelsToRemove "Full Control" -PermissionLevelsToAdd $customRole.Name
                Write-Host "Successfully updated the permission level for the Owner group to $CustomRoleName"
            } else {
                Write-Host "Custom permission level '$CustomRoleName' not found"
            }
        } catch {
            Write-Error "Error assigning custom permission level to Owner group: $_"
        }
    } else {
        Write-Host "Owner group not found"
    }
} catch {
    Write-Error "Error creating custom permission level: $_"
}

# Disconnect the PnP Online session
Disconnect-PnPOnline