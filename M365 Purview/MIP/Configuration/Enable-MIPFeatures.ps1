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

.INSTRUCTIONS
1. Ensure you have the necessary permissions to enable the MIP features.
2. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
3. Run the script using the provided examples or your own parameters.

.PERMISSIONS NEEDED
- Azure Information Protection Administrator
- Global Administrator (if required for certain actions)

.MODULES NEEDED
- AIPService
- ExchangeOnlineManagement
- Microsoft.Online.SharePoint.PowerShell
- AzureADPreview

.PARAMETERS
-action: Specifies which MIP feature to enable. The available actions are:
  - AIPServiceDocumentTracking
  - PdfEncryption
  - MIPIntegrationForSPO_OD
  - MIPForContainers
-URL: The specific URL for SharePoint Online (SPO) integration. This parameter is required for the MIPIntegrationForSPO_OD action.
-UPN: The User Principal Name (UPN) for administrative actions. This parameter is required for the MIPIntegrationForSPO_OD and MIPForContainers actions.

.EXAMPLES
.\MIPFeatureEnabler.ps1 -action AIPServiceDocumentTracking
.\MIPFeatureEnabler.ps1 -action PdfEncryption
.\MIPFeatureEnabler.ps1 -action MIPIntegrationForSPO_OD -URL "https://contoso-admin.sharepoint.com" -UPN "admin@yourdomain.com"
.\MIPFeatureEnabler.ps1 -action MIPForContainers -UPN "admin@yourdomain.com"

.NOTES
Ensure you have the required permissions and configurations in place for these features before using the script.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$action = $env:ACTION,

    [string]$URL = $env:URL,

    [string]$UPN = $env:UPN
)

# Validate parameters
if (-not $action) {
    Write-Error "Action parameter is required."
    exit 1
}

function EnableAIPServiceDocumentTracking {
    try {
        # Check if AIPService module is installed
        if (-not (Get-Module -ListAvailable -Name AIPService)) {
            Install-Module -Name AIPService -Force -ErrorAction Stop
        }
        Import-Module AIPService -ErrorAction Stop
        Connect-AipService -ErrorAction Stop
        Enable-AipServiceDocumentTrackingFeature -ErrorAction Stop
        Write-Output "AIP Service Document Tracking feature enabled successfully."
    } catch {
        Write-Error "Failed to enable AIP Service Document Tracking: $_"
        exit 1
    }
}

function EnablePdfEncryption {
    try {
        # Check if ExchangeOnlineManagement module is installed
        if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
            Install-Module -Name ExchangeOnlineManagement -Force -ErrorAction Stop
        }
        Import-Module ExchangeOnlineManagement -ErrorAction Stop
        Connect-ExchangeOnline -ErrorAction Stop
        Set-IRMConfiguration -EnablePdfEncryption $true -ErrorAction Stop
        Write-Output "PDF Encryption enabled successfully."
    } catch {
        Write-Error "Failed to enable PDF Encryption: $_"
        exit 1
    }
}

function EnableMIPIntegrationForSPO_OD {
    param (
        [string]$URL,
        [string]$UPN
    )
    if (-not $URL -or -not $UPN) {
        Write-Error "Both URL and UPN parameters are required for enabling MIP Integration for SPO/OD."
        exit 1
    }

    try {
        # Check if Microsoft.Online.SharePoint.PowerShell module is installed
        if (-not (Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell)) {
            Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force -ErrorAction Stop
        }
        Update-Module -Name Microsoft.Online.SharePoint.PowerShell -ErrorAction Stop
        Import-Module Microsoft.Online.SharePoint.PowerShell -ErrorAction Stop
        Connect-SPOService -Url $URL -ErrorAction Stop
        Set-SPOTenant -EnableAIPIntegration $true -ErrorAction Stop

        # Check if ExchangeOnlineManagement module is installed
        if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
            Install-Module -Name ExchangeOnlineManagement -Force -ErrorAction Stop
        }
        Import-Module ExchangeOnlineManagement -ErrorAction Stop
        Connect-IPPSSession -UserPrincipalName $UPN -ErrorAction Stop
        Execute-AzureAdLabelSync -ErrorAction Stop
        Write-Output "MIP Integration for SPO/OD enabled successfully."
    } catch {
        Write-Error "Failed to enable MIP Integration for SPO/OD: $_"
        exit 1
    }
}

function EnableMIPForContainers {
    param (
        [string]$UPN
    )
    if (-not $UPN) {
        Write-Error "UPN parameter is required for enabling MIP For Containers."
        exit 1
    }

    try {
        # Check if AzureADPreview module is installed
        if (-not (Get-Module -ListAvailable -Name AzureADPreview)) {
            Install-Module -Name AzureADPreview -Force -ErrorAction Stop
        }
        Import-Module AzureADPreview -ErrorAction Stop
        Connect-AzureAD -ErrorAction Stop
        $grpUnifiedSetting = (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ)
        $Setting = $grpUnifiedSetting
        $Setting["EnableMIPLabels"] = "True"
        Set-AzureADDirectorySetting -Id $grpUnifiedSetting.Id -DirectorySetting $Setting -ErrorAction Stop

        # Check if ExchangeOnlineManagement module is installed
        if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
            Install-Module -Name ExchangeOnlineManagement -Force -ErrorAction Stop
        }
        Import-Module ExchangeOnlineManagement -ErrorAction Stop
        Connect-IPPSSession -UserPrincipalName $UPN -ErrorAction Stop
        Execute-AzureAdLabelSync -ErrorAction Stop
        Write-Output "MIP For Containers enabled successfully."
    } catch {
        Write-Error "Failed to enable MIP For Containers: $_"
        exit 1
    }
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
        exit 1
    }
}
