<#
.SYNOPSIS
This script exports members of an Azure AD group to a CSV file.

.DESCRIPTION
Using the AzureAD module, this script fetches all the user members from a specified Azure AD group and exports them to a CSV file.

.INSTRUCTIONS
1. Ensure you have the AzureAD module installed.
2. Connect to your Azure AD using the Connect-AzureAD cmdlet.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
You need to have sufficient permissions to read members from the specified group in Azure AD.

.MODULES NEEDED
- AzureAD

.PARAMETER GroupId
The ObjectId of the Azure AD group from which members will be exported.

.PARAMETER OutputPath
The file path where the CSV file will be saved.

.EXAMPLE
.\Export-AADGroupMembers.ps1 -GroupId "your-group-id-here" -OutputPath "C:\Path\To\Group.csv"

This will export all user members from the specified group to the specified CSV file.
#>

<#
    -Created by: Wesley Blackwell
    -Date last updated: 5/9/2022

    -Overview:
        Just exports users of group by group id

    -Permissions Needed:
        -Global Admin (confirmed)

    -Modules Needed:
        -AzureAD

    -Notes:
        -
#>

param(
    [string]$GroupId = $env:GROUP_ID,
    [string]$OutputPath = $env:OUTPUT_PATH
)

# Ensure parameters are not empty
if (-not $GroupId) {
    Write-Error "GroupId parameter is empty or not set!"
    exit
}

if (-not $OutputPath) {
    Write-Error "OutputPath parameter is empty or not set!"
    exit
}

Import-Module AzureAD

try {
    Connect-AzureAD
} catch {
    Write-Error "Failed to connect to Azure AD: $_"
    exit
}

try {
    Get-AzureADGroupMember -ObjectId $GroupId | Export-Csv -Path $OutputPath -NoTypeInformation
} catch {
    Write-Error "Error exporting group members: $_"
}