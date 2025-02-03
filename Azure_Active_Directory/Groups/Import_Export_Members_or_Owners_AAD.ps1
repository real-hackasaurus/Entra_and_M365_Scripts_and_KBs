<#
.SYNOPSIS
A script to import or export members and owners of Azure AD groups.

.DESCRIPTION
This script provides functionalities to either import members/owners into Azure AD groups 
from specified CSV files or export members/owners from Azure AD groups into separate 
CSV files. 

The script is designed to handle multiple groups and can process directory inputs containing 
multiple files for the import operation. The file names should match the Azure AD group names 
for accurate processing. For the export operation, files will be created based on the group name.

.PARAMETERS
-accounttype: Specifies whether you're working with "member" or "owner".
-importexport: Specifies the operation, either "import" or "export".
-fileordir: Specifies the path to either a single file or a directory, depending on the operation.
-groups: A comma-separated list of Azure AD groups. This is mandatory for the export operation.

.EXAMPLE
# Import members into Azure AD groups from a directory containing CSV files.
.\Import_Export_Members_or_Owners_AAD.ps1 -accounttype "member" -importexport "import" -fileordir "C:\path\to\file.csv"

.EXAMPLE
# Export members from specific Azure AD groups into a directory.
.\Import_Export_Members_or_Owners_AAD.ps1 -accounttype "member" -importexport "export" -fileordir "C:\path\to\directory\" -groups "Group1, Group2, Group3"

.EXAMPLE
# Import owners into an Azure AD group from a specific CSV file.
.\Import_Export_Members_or_Owners_AAD.ps1 -accounttype "owner" -importexport "import" -fileordir "C:\path\to\file.csv"

.EXAMPLE
# Export owners from a specific Azure AD group into a directory.
.\Import_Export_Members_or_Owners_AAD.ps1 -accounttype "owner" -importexport "export" -fileordir "C:\path\to\directory\" -groups "GroupName"
#>

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("member", "owner")]
    [string]$accounttype,

    [Parameter(Mandatory=$true)]
    [ValidateSet("import", "export")]
    [string]$importexport,

    [Parameter(Mandatory=$true)]
    [string]$fileordir,

    [Parameter(Mandatory=$false)]
    [string]$groups
)

# Authentication process to Azure AD (assuming AzureAD module is installed)
Connect-AzureAD

function Export-AADGroupMembers {
    param (
        [string]$accounttype,
        [string]$fileordir,
        [array]$groupList
    )

    # Ensure $fileordir is a valid directory
    if (-not (Test-Path $fileordir -PathType Container)) {
        Write-Error "The specified path is not a valid directory."
        exit
    }

    foreach ($groupName in $groupList) {
        $group = Get-AzureADGroup -Filter "DisplayName eq '$groupName'"

        if ($group) {
            if ($accounttype -eq "member") {
                $members = Get-AzureADGroupMember -ObjectId $group.ObjectId | Where-Object {$_.ObjectType -eq 'User'}
            } elseif ($accounttype -eq "owner") {
                $members = Get-AzureADGroupOwner -ObjectId $group.ObjectId | Where-Object {$_.ObjectType -eq 'User'}
            }

            # Export members/owners to a file
            $members | Export-Csv -Path "$fileordir\$groupName.csv" -NoTypeInformation
        } else {
            Write-Warning "Group '$groupName' not found."
        }
    }
}

function Import-AADGroupMembers {
    param (
        [string]$accounttype,
        [string]$fileordir
    )

    # Determine if $fileordir is a file or a directory
    $isDirectory = Test-Path $fileordir -PathType Container

    if ($isDirectory) {
        $files = Get-ChildItem -Path $fileordir -Filter "*.csv"
    } else {
        $files = Get-Item -Path $fileordir
    }

    foreach ($file in $files) {
        $users = Import-Csv -Path $file.FullName | ForEach-Object { $_.UserPrincipalName }

        foreach ($upn in $users) {
            $user = Get-AzureADUser -Filter "UserPrincipalName eq '$upn'"
            $group = $file.BaseName # Assumes that the filename is the group's display name

            # Import members/owners from a file
            if ($accounttype -eq "member") {
                Add-AzureADGroupMember -ObjectId (Get-AzureADGroup -Filter "DisplayName eq '$group'").ObjectId -RefObjectId $user.ObjectId
            } elseif ($accounttype -eq "owner") {
                Add-AzureADGroupOwner -ObjectId (Get-AzureADGroup -Filter "DisplayName eq '$group'").ObjectId -RefObjectId $user.ObjectId
            }
        }
    }
}

# Execution
switch ($importexport) {
    "export" {
        if (-not $groups) {
            Write-Error "For the export operation, the -groups parameter must be specified."
            exit
        }

        $groupList = $groups -split ',' | ForEach-Object { $_.Trim() }
        Export-AADGroupMembers -accounttype $accounttype -fileordir $fileordir -groupList $groupList
    }
    "import" {
        Import-AADGroupMembers -accounttype $accounttype -fileordir $fileordir
    }
}