<#
.SYNOPSIS
A script to enable various MIP features.

.DESCRIPTION
This script provides functions to enable specific MIP features based on the provided action.
The available features are:
- AIP Service Document Tracking
- PDF Encryption
- MIP Integration for SharePoint Online (SPO) and OneDrive (OD)
- MIP for Containers

.PARAMETER action
Specifies which MIP feature to enable. The available actions are:
- AIPServiceDocumentTracking
- PdfEncryption
- MIPIntegrationForSPO_OD
- MIPForContainers

.PARAMETER URL
The specific URL for SharePoint Online (SPO) integration. This parameter is required for the MIPIntegrationForSPO_OD action.

.PARAMETER UPN
The User Principal Name (UPN) for administrative actions. This parameter is required for the MIPIntegrationForSPO_OD and MIPForContainers actions.

.EXAMPLE
.\MIPFeatureEnabler.ps1 -action AIPServiceDocumentTracking

.EXAMPLE
.\MIPFeatureEnabler.ps1 -action PdfEncryption

.EXAMPLE
.\MIPFeatureEnabler.ps1 -action MIPIntegrationForSPO_OD -URL "https://contoso-admin.sharepoint.com" -UPN "admin@yourdomain.com"

.EXAMPLE
.\MIPFeatureEnabler.ps1 -action MIPForContainers -UPN "admin@yourdomain.com"

.NOTES
Ensure you have the required permissions and configurations in place for these features before using the script.

#>

param (
    [Parameter(Mandatory=$true)]
    [string]$action,

    [string]$URL,

    [string]$UPN
)

function EnableAIPServiceDocumentTracking {
    Import-Module AIPService
    Connect-AipService
    Enable-AipServiceDocumentTrackingFeature
}

function EnablePdfEncryption {
    Import-Module ExchangeOnlineManagement
    Connect-ExchangeOnline
    Set-IRMConfiguration -EnablePdfEncryption $true
}

function EnableMIPIntegrationForSPO_OD {
    param (
        [string]$URL,
        [string]$UPN
    )
    if (-not $URL -or -not $UPN) {
        throw "Both URL and UPN parameters are required for enabling MIP Integration for SPO/OD."
    }

    Update-Module -Name Microsoft.Online.SharePoint.PowerShell
    Connect-SPOService -Url $URL
    Set-SPOTenant -EnableAIPIntegration $true

    Import-Module ExchangeOnlineManagement
    Connect-IPPSSession -UserPrincipalName $UPN
    Execute-AzureAdLabelSync
}

function EnableMIPForContainers {
    param (
        [string]$UPN
    )
    if (-not $UPN) {
        throw "UPN parameter is required for enabling MIP For Containers."
    }

    Import-Module AzureADPreview
    Connect-AzureAD
    $grpUnifiedSetting = (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ)
    $Setting = $grpUnifiedSetting
    $Setting["EnableMIPLabels"] = "True"
    Set-AzureADDirectorySetting -Id $grpUnifiedSetting.Id -DirectorySetting $Setting

    Import-Module ExchangeOnlineManagement
    Connect-IPPSSession -UserPrincipalName $UPN
    Execute-AzureAdLabelSync
}

switch ($action) {
    "AIPServiceDocumentTracking" {
        EnableAIPServiceDocumentTracking
    }
    "PdfEncryption" {
        EnablePdfEncryption
    }
    "MIPIntegrationForSPO_OD" {
        EnableMIPIntegrationForSPO_OD -URL $URL -UPN $UPN
    }
    "MIPForContainers" {
        EnableMIPForContainers -UPN $UPN
    }
    default {
        Write-Error "Invalid action specified. Please select a valid action."
    }
}
