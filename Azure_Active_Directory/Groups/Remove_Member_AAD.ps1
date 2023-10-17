<#
.SYNOPSIS
This script removes specified users from an Azure Active Directory (AAD) group.

.DESCRIPTION
This script connects to Azure AD using the AzureAD module and removes the provided users from a specified AAD group. 
The users to be removed are passed as a comma-separated string.
The group and users are specified as command line parameters.

.PARAMETER groupName
The name of the Azure Active Directory group from which users will be removed.

.PARAMETER users
A comma-separated string of user principal names to be removed from the specified group.

.EXAMPLE
.\Remove_Member_AAD.ps1 -groupName "MyTestGroup" -users "user1@example.com,user2@example.com,user3@example.com"

This will attempt to remove the users user1@example.com, user2@example.com, and user3@example.com from the group named "MyTestGroup" in Azure AD.

#>

# Ensure AzureAD module is installed
if (-not (Get-Module -ListAvailable -Name AzureAD)) {
    Install-Module -Name AzureAD -Confirm:$false -Force
}

# Import the AzureAD module
Import-Module AzureAD

# Get command line parameters
param (
    [Parameter(Mandatory=$true)]
    [string]$groupName,

    [Parameter(Mandatory=$true)]
    [string]$users
)

# Connect to Azure AD
Connect-AzureAD

# Get the group based on the group name
$group = Get-AzureADGroup -Filter "DisplayName eq '$groupName'"

if ($null -eq $group) {
    Write-Error "Group '$groupName' not found."
    exit 1
}

# Split the user string into individual usernames and remove them from the group
$users.Split(',').Trim() | ForEach-Object {
    $user = Get-AzureADUser -Filter "UserPrincipalName eq '$_'"
    
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