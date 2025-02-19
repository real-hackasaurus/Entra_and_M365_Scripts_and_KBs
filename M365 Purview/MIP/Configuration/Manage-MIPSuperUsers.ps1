<#
.SYNOPSIS
This script provides management capabilities for MIP super users.

.DESCRIPTION
Supported actions:
- enable
- disable
- adduser
- addgroup
- removeuser
- removegroup
- listallsuperusers
- listcurrentstate

.INSTRUCTIONS
1. Ensure you have the necessary permissions to manage MIP super users.
2. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
3. Run the script using the provided examples or your own parameters.

.PERMISSIONS NEEDED
- Azure Information Protection Administrator
- Global Administrator (if required for certain actions)

.MODULES NEEDED
- AIPService

.PARAMETERS
-Action: The action to be performed.
-User: The username for actions that require it.
-Group: The group name for actions that require it.

.EXAMPLES
# Enable the Super User feature
.\Manage-MIPSuperUsers.ps1 -Action "enable"

# Disable the Super User feature
.\Manage-MIPSuperUsers.ps1 -Action "disable"

# Add specific users as super users
.\Manage-MIPSuperUsers.ps1 -Action "adduser" -User "user1@example.com,user2@example.com"

# Remove specific users from the super user list
.\Manage-MIPSuperUsers.ps1 -Action "removeuser" -User "user1@example.com,user2@example.com"

# Set a group as the super user group
.\Manage-MIPSuperUsers.ps1 -Action "addgroup" -Group "groupemail@example.com"

# Remove the designated super user group
.\Manage-MIPSuperUsers.ps1 -Action "removegroup"

# List all super users and the super user group
.\Manage-MIPSuperUsers.ps1 -Action "listallsuperusers"

# Display the current state of the Super User feature
.\Manage-MIPSuperUsers.ps1 -Action "listcurrentstate"
#>

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("enable", "disable", "adduser", "addgroup", "removeuser", "removegroup", "listallsuperusers", "listcurrentstate")]
    [string]$Action = $env:ACTION,

    [string]$User = $env:USER,

    [string]$Group = $env:GROUP
)

# Validate parameters
if (-not $Action) {
    Write-Error "Action parameter is required."
    exit 1
}

# Check if AIPService module is installed
if (-not (Get-Module -ListAvailable -Name AIPService)) {
    try {
        Install-Module -Name AIPService -Force -ErrorAction Stop
    } catch {
        Write-Error "Failed to install AIPService module: $_"
        exit 1
    }
}

try {
    # Connect to AIP Service
    Import-Module AIPService -ErrorAction Stop
    Connect-AipService -ErrorAction Stop
} catch {
    Write-Error "Failed to connect to AIP service: $_"
    exit 1
}

function EnableSuperUser {
    try {
        Enable-AipServiceSuperUserFeature -ErrorAction Stop
        Write-Output "Super User feature has been successfully enabled."
    } catch {
        Write-Error "Failed to enable Super User feature: $_"
        exit 1
    }
}

function DisableSuperUser {
    try {
        Disable-AipServiceSuperUserFeature -ErrorAction Stop
        Write-Output "Super User feature has been successfully disabled."
    } catch {
        Write-Error "Failed to disable Super User feature: $_"
        exit 1
    }
}

function AddUser([string]$users) {
    $userArray = $users -split ',' | ForEach-Object { $_.Trim() }
    try {
        foreach ($user in $userArray) {
            Add-AipServiceSuperUser -EmailAddress $user -ErrorAction Stop
            Write-Output "Successfully added $user as a super user."
        }
    } catch {
        Write-Error "Failed to add $user as a super user: $_"
        exit 1
    }
}

function AddGroup([string]$group) {
    Write-Warning "DISCLAIMER: All users in this group are super users. This action will effectively make them owners of all content in the organization."
    Write-Warning "DISCLAIMER: Any new group added with this command will overwrite the previous group. You can have multiple super users, but only one super user group at a time."
    Write-Warning "DISCLAIMER: The group has to have an email address to function properly."
    Write-Warning "DISCLAIMER: Group memberships are cached. For real-time access, you need to add the user individually."
    try {
        Set-AipServiceSuperUserGroup -GroupEmailAddress $group -ErrorAction Stop
        Write-Output "Successfully set $group as the super user group."
    } catch {
        Write-Error "Failed to set $group as the super user group: $_"
        exit 1
    }
}

function RemoveUser([string]$users) {
    $userArray = $users -split ',' | ForEach-Object { $_.Trim() }
    try {
        foreach ($user in $userArray) {
            Remove-AipServiceSuperUser -EmailAddress $user -ErrorAction Stop
            Write-Output "Successfully removed $user from super users."
        }
    } catch {
        Write-Error "Failed to remove $user from super users: $_"
        exit 1
    }
}

function RemoveGroup {
    Write-Warning "DISCLAIMER: You are about to remove the super user group."
    try {
        Clear-AipServiceSuperUserGroup -ErrorAction Stop
        Write-Output "Successfully removed the super user group."
    } catch {
        Write-Error "Failed to remove the super user group: $_"
        exit 1
    }
}

function ListAllSuperUsers {
    try {
        $superUsers = Get-AipServiceSuperUser -ErrorAction Stop
        if ($superUsers -ne $null -and $superUsers.Count -gt 0) {
            Write-Output "List of Super Users:"
            $superUsers | ForEach-Object {
                Write-Output $_
            }
        } else {
            Write-Output "No super users found."
        }
        $superUserGroup = Get-AipServiceSuperUserGroup -ErrorAction Stop
        if ($superUserGroup) {
            Write-Output "Super User Group:"
            Write-Output $superUserGroup.GroupEmailAddress
        } else {
            Write-Output "No super user group set."
        }
    } catch {
        Write-Error "Failed to list super users: $_"
        exit 1
    }
}

function ListCurrentState {
    try {
        $superUserFeatureState = Get-AipServiceSuperUserFeature -ErrorAction Stop
        if ($superUserFeatureState.Enabled) {
            Write-Output "Super User feature is currently ENABLED."
        } else {
            Write-Output "Super User feature is currently DISABLED."
        }
    } catch {
        Write-Error "Failed to fetch the current state of the Super User feature: $_"
        exit 1
    }
}

switch ($Action) {
    "enable" {
        EnableSuperUser
    }
    "disable" {
        DisableSuperUser
    }
    "adduser" {
        AddUser -users $User
    }
    "addgroup" {
        AddGroup -group $Group
    }
    "removeuser" {
        RemoveUser -users $User
    }
    "removegroup" {
        RemoveGroup
    }
    "listallsuperusers" {
        ListAllSuperUsers
    }
    "listcurrentstate" {
        ListCurrentState
    }
}