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
