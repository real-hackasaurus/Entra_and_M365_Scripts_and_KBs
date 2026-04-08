<#
.SYNOPSIS
Allows for creating a guest user in the AAD environment.

.DESCRIPTION
This script connects to Azure AD using the Microsoft Graph module and creates a single guest user based on the provided parameters.

.INSTRUCTIONS
1. Ensure you have the Microsoft.Graph module installed.
2. Connect to your Azure AD using the Connect-MgGraph cmdlet.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
You need to have sufficient permissions to create guest users in Azure AD.

.MODULES NEEDED
- Microsoft.Graph

.PARAMETER DisplayName
The display name for the new guest user.

.PARAMETER EmailAddress
The email address of the new guest user.

.PARAMETER RedirectUrl
The URL to redirect the guest user to after accepting the invitation.

.PARAMETER SendInvite
Whether to send an invitation email to the guest user.

.EXAMPLE
.\Invite-GuestUser.ps1 -DisplayName "John Doe" -EmailAddress "johndoe@example.com" -RedirectUrl "https://myportal.example.com" -SendInvite $true

This will create a guest user invitation for the specified email address.

.NOTES
File Name      : Invite-GuestUser.ps1
Author         : Wes Blackwell
Prerequisite   : Microsoft.Graph Module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$DisplayName = $env:DISPLAY_NAME,

    [Parameter(Mandatory=$true)]
    [string]$EmailAddress = $env:EMAIL_ADDRESS,

    [Parameter(Mandatory=$true)]
    [string]$RedirectUrl = $env:REDIRECT_URL,

    [Parameter(Mandatory=$true)]
    [bool]$SendInvite = [bool]::Parse($env:SEND_INVITE)
)

// Ensure parameters are not empty
if (-not $DisplayName) {
    Write-Error "DisplayName parameter is empty or not set!"
    exit
}

if (-not $EmailAddress) {
    Write-Error "EmailAddress parameter is empty or not set!"
    exit
}

if (-not $RedirectUrl) {
    Write-Error "RedirectUrl parameter is empty or not set!"
    exit
}

Function InstallModule {
    try {
        Install-Module PowerShellGet -Force
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        Install-Module Microsoft.Graph -Scope AllUsers
    } catch {
        Write-Error "Failed to install required modules: $_"
    }
}

// InstallModule

try {
    Connect-MgGraph -Scopes user.readwrite.all
} catch {
    Write-Error "Failed to connect to Microsoft Graph: $_"
    exit
}

try {
    New-MgInvitation -InvitedUserDisplayName $DisplayName -InvitedUserEmailAddress $EmailAddress -InviteRedirectUrl $RedirectUrl -SendInvitationMessage:$SendInvite
} catch {
    Write-Error "Error inviting user $EmailAddress $_"
}