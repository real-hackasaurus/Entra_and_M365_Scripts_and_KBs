##############################################################################
##
## Bulk_Create_Guest_User.ps1
##
## Created by: Wesley Blackwell
## Date of last modification: 5/25/2022
##
##############################################################################

<#

.SYNOPSIS

Allows for creating mulitple guest users in the AAD enviornment via csv.
#>

Function InstallModule {
    Install-Module PowerShellGet -Force
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Install-Module Microsoft.Graph -Scope AllUsers

}

#InstallModule

Connect-MgGraph -Scopes user.readwrite.all

$p = Import-Csv -Path '.\Bulk_User_Template.csv'
foreach($eachline in $p){
    $SendInvite = [System.Convert]::ToBoolean($eachline.SendInvite)
    New-MgInvitation -InvitedUserDisplayName $eachline.DisplayName -InvitedUserEmailAddress $eachline.EmailAddress -InviteRedirectUrl $eachline.RedirectUrl -SendInvitationMessage:$false
}