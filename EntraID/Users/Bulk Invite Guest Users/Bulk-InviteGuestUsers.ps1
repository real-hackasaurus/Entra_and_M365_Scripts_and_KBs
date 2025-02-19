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
Allows for creating multiple guest users in the AAD environment via CSV.

.DESCRIPTION
This script connects to Azure AD using the Microsoft Graph module and creates multiple guest users based on the information provided in a CSV file.

.INSTRUCTIONS
1. Ensure you have the Microsoft.Graph module installed.
2. Connect to your Azure AD using the Connect-MgGraph cmdlet.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
You need to have sufficient permissions to create guest users in Azure AD.

.MODULES NEEDED
- Microsoft.Graph

.PARAMETER CsvPath
The path to the CSV file containing the guest user information.

.EXAMPLE
.\Bulk-InviteGuestUsers.ps1 -CsvPath "C:\Path\To\Bulk_User_Template.csv"

This will create guest users based on the information in the specified CSV file.

.NOTES
File Name      : Bulk-InviteGuestUsers.ps1
Author         : Wes Blackwell
Prerequisite   : Microsoft.Graph Module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$CsvPath = $env:CSV_PATH
)

# Ensure parameters are not empty
if (-not $CsvPath) {
    Write-Error "CsvPath parameter is empty or not set!"
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

# InstallModule

try {
    Connect-MgGraph -Scopes user.readwrite.all
} catch {
    Write-Error "Failed to connect to Microsoft Graph: $_"
    exit
}

try {
    $p = Import-Csv -Path $CsvPath
    foreach ($eachline in $p) {
        try {
            $SendInvite = [System.Convert]::ToBoolean($eachline.SendInvite)
            New-MgInvitation -InvitedUserDisplayName $eachline.DisplayName -InvitedUserEmailAddress $eachline.EmailAddress -InviteRedirectUrl $eachline.RedirectUrl -SendInvitationMessage:$false
        } catch {
            Write-Error "Error inviting user $($eachline.EmailAddress): $_"
        }
    }
} catch {
    Write-Error "Error processing CSV file: $_"
}