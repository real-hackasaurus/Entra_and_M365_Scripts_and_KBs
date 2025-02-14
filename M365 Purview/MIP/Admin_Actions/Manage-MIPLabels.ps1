<#
.SYNOPSIS
This script provides functions to manage MIP labels on files within a specified directory.

.DESCRIPTION
Based on the specified action, it either applies or removes MIP labels on files.

.NOTES
Ensure you have the required permissions and prerequisites before executing this script.

.EXAMPLE
# Apply a specific label to files in a directory
ManageLabel -Path "C:\example" -Action "apply" -LabelId "d9f23ae3-1234-1234-1234-f515f824c57b"

.EXAMPLE
# Remove labels from files in a directory
ManageLabel -Path "C:\example" -Action "remove"
#>

# Importing the AzureInformationProtection module
Import-Module AzureInformationProtection

# Connect to the AIP Service
Connect-AipService

# Display disclaimers
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