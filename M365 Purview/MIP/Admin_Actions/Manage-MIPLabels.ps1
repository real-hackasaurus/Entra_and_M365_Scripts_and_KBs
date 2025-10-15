<#
.SYNOPSIS
This script provides functions to manage MIP labels on files within a specified directory.

.DESCRIPTION
Based on the specified action, it either applies or removes MIP labels on files.

.NOTES
Ensure you have the required permissions and prerequisites before executing this script.

.PARAMETER Path
The directory path where the files are located.

.PARAMETER Action
The action to perform, either "apply" or "remove".

.PARAMETER LabelId
The ID of the label to apply. This parameter is mandatory when the action is "apply".

.EXAMPLE
# Apply a specific label to files in a directory
.\Manage-MIPLabels.ps1 -Path "C:\example" -Action "apply" -LabelId "d9f23ae3-1234-1234-1234-f515f824c57b"

.EXAMPLE
# Remove labels from files in a directory
.\Manage-MIPLabels.ps1 -Path "C:\example" -Action "remove"

.NOTES
File Name      : Manage-MIPLabels.ps1
Author         : Wes Blackwell
Prerequisite   : AzureInformationProtection Module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$Path = $env:FILE_PATH,

    [Parameter(Mandatory=$true)]
    [ValidateSet('apply', 'remove')]
    [string]$Action = $env:ACTION,

    [Parameter(Mandatory=$false)]
    [ValidateScript({
        if ($Action -eq 'apply' -and (-not $_)) {
            throw "LabelId is mandatory when the action is 'apply'."
        }
        return $true
    })]
    [string]$LabelId = $env:LABEL_ID
)

// Ensure parameters are not empty
try {
    if (-not $Path) {
        Write-Error "Path parameter is empty or not set!"
        exit
    }

    if (-not $Action) {
        Write-Error "Action parameter is empty or not set!"
        exit
    }

    if ($Action -eq 'apply' -and (-not $LabelId)) {
        Write-Error "LabelId parameter is empty or not set!"
        exit
    }
} catch {
    Write-Error "Error checking parameters: $_"
    exit
}

// Importing the AzureInformationProtection module
try {
    if (-not (Get-Module -ListAvailable -Name AzureInformationProtection)) {
        Install-Module -Name AzureInformationProtection -Force
    }
    Import-Module AzureInformationProtection
} catch {
    Write-Error "Failed to install or import AzureInformationProtection module: $_"
    exit
}

// Connect to the AIP Service
try {
    Connect-AipService
} catch {
    Write-Error "Failed to connect to AIP Service: $_"
    exit
}

// Display disclaimers
Write-Warning "DISCLAIMER: The workstation executing this script must have the Unified Labeling Client installed, which contains the necessary AzureInformationProtection PowerShell module."
Write-Warning "DISCLAIMER: The user signed into the workstation should have been assigned all the labels that are intended to be processed by this script."

function ManageLabel {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$Path,

        [Parameter(Mandatory=$true)]
        [ValidateSet('apply', 'remove')]
        [string]$Action,

        [Parameter(Mandatory=$false)]
        [ValidateScript({
            if ($Action -eq 'apply' -and (-not $_)) {
                throw "LabelId is mandatory when the action is 'apply'."
            }
            return $true
        })]
        [string]$LabelId
    )

    process {
        if ($Action -eq 'apply') {
            Get-ChildItem $Path -File -Recurse |
            Get-AIPFileStatus |
            Where-Object {$_.IsLabeled -eq $False} |
            Set-AIPFileLabel -LabelId $LabelId
        } elseif ($Action -eq 'remove') {
            Get-ChildItem $Path -File -Recurse |
            Set-AIPFileLabel -RemoveLabel
        }
    }
}

// Execute the ManageLabel function
ManageLabel -Path $Path -Action $Action -LabelId $LabelId