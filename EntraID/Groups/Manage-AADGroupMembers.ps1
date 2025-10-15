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

.INSTRUCTIONS
1. Ensure you have the AzureAD module installed.
2. Connect to your Azure AD using the Connect-AzureAD cmdlet.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
You need to have sufficient permissions to read and write members/owners in the specified groups in Azure AD.

.MODULES NEEDED
- AzureAD

.PARAMETER accounttype
Specifies whether you're working with "member" or "owner".

.PARAMETER importexport
Specifies the operation, either "import" or "export".

.PARAMETER fileordir
Specifies the path to either a single file or a directory, depending on the operation.

.PARAMETER groups
A comma-separated list of Azure AD groups. This is mandatory for the export operation.

.EXAMPLE
# Import members into Azure AD groups from a directory containing CSV files.
.\Manage-AADGroupMembers.ps1 -accounttype "member" -importexport "import" -fileordir "C:\path\to\file.csv"

.EXAMPLE
# Export members from specific Azure AD groups into a directory.
.\Manage-AADGroupMembers.ps1 -accounttype "member" -importexport "export" -fileordir "C:\path\to\directory\" -groups "Group1, Group2, Group3"

.EXAMPLE
# Import owners into an Azure AD group from a specific CSV file.
.\Manage-AADGroupMembers.ps1 -accounttype "owner" -importexport "import" -fileordir "C:\path\to\file.csv"

.EXAMPLE
# Export owners from a specific Azure AD group into a directory.
.\Manage-AADGroupMembers.ps1 -accounttype "owner" -importexport "export" -fileordir "C:\path\to\directory\" -groups "GroupName"
#>

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("member", "owner")]
    [string]$accounttype = $env:ACCOUNT_TYPE,

    [Parameter(Mandatory=$true)]
    [ValidateSet("import", "export")]
    [string]$importexport = $env:IMPORT_EXPORT,

    [Parameter(Mandatory=$true)]
    [string]$fileordir = $env:FILE_OR_DIR,

    [Parameter(Mandatory=$false)]
    [string]$groups = $env:GROUPS
)

# Ensure parameters are not empty
if (-not $accounttype) {
    Write-Error "AccountType parameter is empty or not set!"
    exit
}

if (-not $importexport) {
    Write-Error "ImportExport parameter is empty or not set!"
    exit
}

if (-not $fileordir) {
    Write-Error "FileOrDir parameter is empty or not set!"
    exit
}

# Authentication process to Azure AD (assuming AzureAD module is installed)
try {
    Connect-AzureAD
} catch {
    Write-Error "Failed to connect to Azure AD: $_"
    exit
}

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
        try {
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
        } catch {
            Write-Error "Error exporting members/owners for group '$groupName': $_"
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
        try {
            $users = Import-Csv -Path $file.FullName | ForEach-Object { $_.UserPrincipalName }

            foreach ($upn in $users) {
                try {
                    $user = Get-AzureADUser -Filter "UserPrincipalName eq '$upn'"
                    $group = $file.BaseName # Assumes that the filename is the group's display name

                    # Import members/owners from a file
                    if ($accounttype -eq "member") {
                        Add-AzureADGroupMember -ObjectId (Get-AzureADGroup -Filter "DisplayName eq '$group'").ObjectId -RefObjectId $user.ObjectId
                    } elseif ($accounttype -eq "owner") {
                        Add-AzureADGroupOwner -ObjectId (Get-AzureADGroup -Filter "DisplayName eq '$group'").ObjectId -RefObjectId $user.ObjectId
                    }
                } catch {
                    Write-Error "Error adding user '$upn' to group '$group': $_"
                }
            }
        } catch {
            Write-Error "Error importing members/owners from file '$($file.FullName)': $_"
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