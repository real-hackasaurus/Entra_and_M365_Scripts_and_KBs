<#
.SYNOPSIS
This script removes specified users from multiple Azure Active Directory (AAD) groups.

.DESCRIPTION
This script connects to Azure AD using the AzureAD module and removes the provided users from the specified AAD groups. 
The users to be removed and groups are passed as comma-separated strings.
Both groups and users are specified as command line parameters.

.PARAMETER groupNames
A comma-separated string of Azure Active Directory group names from which users will be removed.

.PARAMETER users
A comma-separated string of user principal names to be removed from the specified groups.

.EXAMPLE
.\Remove_Member_AAD.ps1 -groupNames "Group1,Group2" -users "user1@example.com,user2@example.com"

This will attempt to remove the users user1@example.com and user2@example.com from the groups named "Group1" and "Group2" in Azure AD.

#>

# Get command line parameters
param (
    [Parameter(Mandatory=$true)]
    [string]$groupNames,

    [Parameter(Mandatory=$true)]
    [string]$users
)

# Connect to Azure AD
Connect-AzureAD

# Split the groupNames string into individual group names
$groupNames.Split(',').Trim() | ForEach-Object {
    $groupName = $_
    $group = Get-AzureADGroup -Filter "DisplayName eq '$groupName'"

    if ($null -eq $group) {
        Write-Error "Group '$groupName' not found."
        continue
    }

    # Split the user string into individual usernames and remove them from the group
    $users.Split(',').Trim() | ForEach-Object {
        $user = Get-AzureADUser -Filter "mail eq '$_'"

        if ($null -eq $user) {
            Write-Warning "User '$_' not found."
        } else {
            try {
                Remove-AzureADGroupMember -ObjectId $group.ObjectId -MemberId $user.ObjectId
                Write-Output "Removed user '$_' from group '$groupName'."
            } catch {
                Write-Error "Failed to remove user '$_' from group '$groupName'. Error: $_"
            }
        }
    }
}
