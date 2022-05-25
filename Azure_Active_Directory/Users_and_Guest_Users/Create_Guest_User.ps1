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

Allows for creating a guest user in the AAD enviornment.
#>

Function InstallModule {
    Install-Module PowerShellGet -Force
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Install-Module Microsoft.Graph -Scope AllUsers

}

#InstallModule

Connect-MgGraph -Scopes user.readwrite.all
#UPDATE: update below with necessary information: Display name, email address, redirect url (not often changed), and sendinvite boolean 
New-MgInvitation -InvitedUserDisplayName "FirstName LastName" -InvitedUserEmailAddress user@contoso.com -InviteRedirectUrl "https://myapplications.microsoft.com" -SendInvitationMessage:$false