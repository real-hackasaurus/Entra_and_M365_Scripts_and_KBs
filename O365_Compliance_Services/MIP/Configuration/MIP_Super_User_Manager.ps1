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

.PARAMETER Action
The action to be performed.

.PARAMETER User
The username for actions that require it.

.PARAMETER Group
The group name for actions that require it.

.EXAMPLE

# Enable the Super User feature
EnableSuperUser

# Disable the Super User feature
DisableSuperUser

# Add specific users as super users
AddUser -users "user1@example.com,user2@example.com"

# Remove specific users from the super user list
RemoveUser -users "user1@example.com,user2@example.com"

# Set a group as the super user group
AddGroup -group "groupemail@example.com"

# Remove the designated super user group
RemoveGroup

# List all super users and the super user group
ListAllSuperUsers

# Display the current state of the Super User feature
ListCurrentState
#>

# If needed, install module with below
# Install-Module -Name AIPService -Force -AllowClobber

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("enable", "disable", "adduser", "addgroup", "removeuser", "removegroup", "listallsuperusers", "listcurrentstate")]
    [string]$Action,

    [Parameter(Mandatory=$false)]
    [string]$User,

    [Parameter(Mandatory=$false)]
    [string]$Group
)

# Connect to AIP Service
Connect-AipService

function EnableSuperUser() {
    function EnableSuperUser() {
        try {
            # Enabling the super user functionality
            Enable-AipServiceSuperUserFeature
    
            Write-Output "Super User feature has been successfully enabled."
        } catch {
            # Catching any exceptions or errors that occur
            Write-Error "Failed to enable Super User feature. Error: $_"
        }
    }
}

function DisableSuperUser() {
    function DisableSuperUser() {
        try {
            # Disabling the super user functionality
            Disable-AipServiceSuperUserFeature
    
            Write-Output "Super User feature has been successfully disabled."
        } catch {
            # Catching any exceptions or errors that occur
            Write-Error "Failed to disable Super User feature. Error: $_"
        }
    }    
}

function AddUser([string]$user) {
    function AddUser([string]$users) {
        # Splitting the provided comma-separated users into an array
        $userArray = $users -split ',' | ForEach-Object { $_.Trim() }
    
        try {
            foreach ($user in $userArray) {
                # Adding each user as a super user
                Add-AipServiceSuperUser -EmailAddress $user
    
                Write-Output "Successfully added $user as a super user."
            }
        } catch {
            # Catching any exceptions or errors that occur
            Write-Error "Failed to add $user as a super user. Error: $_"
        }
    }    
}

function AddGroup([string]$group) {
    function AddGroup([string]$group) {
        # Disclaimers
        Write-Warning "DISCLAIMER: All users in this group are super users. This action will effectively make them owners of all content in the organization."
        Write-Warning "DISCLAIMER: Any new group added with this command will overwrite the previous group. You can have multiple super users, but only one super user group at a time."
        Write-Warning "DISCLAIMER: The group has to have an email address to function properly."
        Write-Warning "DISCLAIMER: Group memberships are cached. For real-time access, you need to add the user individually."
    
        try {
            # Adding the group as super user group
            Set-AipServiceSuperUserGroup -GroupEmailAddress $group
    
            Write-Output "Successfully set $group as the super user group."
        } catch {
            # Catching any exceptions or errors that occur
            Write-Error "Failed to set $group as the super user group. Error: $_"
        }
    }    
}

function RemoveUser([string]$user) {
    function RemoveUser([string]$users) {
        # Splitting the provided comma-separated users into an array
        $userArray = $users -split ',' | ForEach-Object { $_.Trim() }
    
        try {
            foreach ($user in $userArray) {
                # Removing each user from super users
                Remove-AipServiceSuperUser -EmailAddress $user
    
                Write-Output "Successfully removed $user from super users."
            }
        } catch {
            # Catching any exceptions or errors that occur
            Write-Error "Failed to remove $user from super users. Error: $_"
        }
    }    
}

function RemoveGroup([string]$group) {
    function RemoveGroup() {
        # Disclaimers
        Write-Warning "DISCLAIMER: You are about to remove the super user group."
    
        try {
            # Clearing the super user group
            Clear-AipServiceSuperUserGroup
    
            Write-Output "Successfully removed the super user group."
        } catch {
            # Catching any exceptions or errors that occur
            Write-Error "Failed to remove the super user group. Error: $_"
        }
    }    
}

function ListAllSuperUsers() {
    function ListAllSuperUsers() {
        # Fetching and listing all super users
        $superUsers = Get-AipServiceSuperUser
        if ($superUsers -ne $null -and $superUsers.Count -gt 0) {
            Write-Output "List of Super Users:"
            $superUsers | ForEach-Object {
                Write-Output $_
            }
        } else {
            Write-Output "No super users found."
        }
    
        # Fetching and listing the super user group
        $superUserGroup = Get-AipServiceSuperUserGroup
        if ($superUserGroup) {
            Write-Output "Super User Group:"
            Write-Output $superUserGroup.GroupEmailAddress
        } else {
            Write-Output "No super user group set."
        }
    }    
}

function ListCurrentState() {
    function ListCurrentState() {
        try {
            # Fetching the current state of the super user feature
            $superUserFeatureState = Get-AipServiceSuperUserFeature
    
            # Checking the status and displaying appropriate message
            if ($superUserFeatureState.Enabled) {
                Write-Output "Super User feature is currently ENABLED."
            } else {
                Write-Output "Super User feature is currently DISABLED."
            }
        } catch {
            # Catching any exceptions or errors that occur
            Write-Error "Failed to fetch the current state of the Super User feature. Error: $_"
        }
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
        AddUser -User $User
    }
    "addgroup" {
        AddGroup -Group $Group
    }
    "removeuser" {
        RemoveUser -User $User
    }
    "removegroup" {
        RemoveGroup -Group $Group
    }
    "listallsuperusers" {
        ListAllSuperUsers
    }
    "listcurrentstate" {
        ListCurrentState
    }
}