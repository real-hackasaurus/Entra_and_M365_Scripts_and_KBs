##############################################################################
##
## Create_Guest_User.ps1
##
## Created by: Wesley Blackwell
## Date of last modification: 5/25/2022
##
##############################################################################

<#
.SYNOPSIS
Allows for creating a guest user in the AAD environment.
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