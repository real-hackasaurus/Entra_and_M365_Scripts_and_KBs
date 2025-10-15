<#
.SYNOPSIS
This script removes specified users from multiple Azure Active Directory (AAD) groups.

.DESCRIPTION
This script connects to Azure AD using the AzureAD module and removes the provided users from the specified AAD groups. 
The users to be removed and groups are passed as comma-separated strings.
Both groups and users are specified as command line parameters.

.INSTRUCTIONS
1. Ensure you have the AzureAD module installed.
2. Connect to your Azure AD using the Connect-AzureAD cmdlet.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
You need to have sufficient permissions to remove members from the specified groups in Azure AD.

.MODULES NEEDED
- AzureAD

.PARAMETER groupNames
A comma-separated string of Azure Active Directory group names from which users will be removed.

.PARAMETER users
A comma-separated string of user principal names to be removed from the specified groups.

.EXAMPLE
.\Remove-AADGroupMembers.ps1 -groupNames "Group1,Group2" -users "user1@example.com,user2@example.com"

This will attempt to remove the users user1@example.com and user2@example.com from the groups named "Group1" and "Group2" in Azure AD.
#>

# Get command line parameters
param (
    [Parameter(Mandatory=$true)]
    [string]$groupNames = $env:GROUP_NAMES,

    [Parameter(Mandatory=$true)]
    [string]$users = $env:USERS
)

# Ensure parameters are not empty
if (-not $groupNames) {
    Write-Error "GroupNames parameter is empty or not set!"
    exit
}

if (-not $users) {
    Write-Error "Users parameter is empty or not set!"
    exit
}

# Connect to Azure AD
try {
    Connect-AzureAD
} catch {
    Write-Error "Failed to connect to Azure AD: $_"
    exit
}

# Split the groupNames string into individual group names
$groupNames.Split(',').Trim() | ForEach-Object {
    $groupName = $_
    try {
        $group = Get-AzureADGroup -Filter "DisplayName eq '$groupName'"

        if ($null -eq $group) {
            Write-Error "Group '$groupName' not found."
            continue
        }

        # Split the user string into individual usernames and remove them from the group
        $users.Split(',').Trim() | ForEach-Object {
            try {
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
            } catch {
                Write-Error "Error retrieving user '$_': $_"
            }
        }
    } catch {
        Write-Error "Error retrieving group '$groupName': $_"
    }
}
