<#
.SYNOPSIS
Exports configurations for MIP.

.DESCRIPTION
This script provides functionality to export configurations for Microsoft Information Protection (MIP).

.PARAMETER Action
Specifies which action to perform. Valid options are:
- AIP Service Configuration
- IRM Configuration
- MIP Labels
- MIP Label Policies

.PARAMETER ExportPath
Specifies the directory path where the exported information will be saved.

.PARAMETER UPN
User Principal Name required for exporting the IRM Configuration, MIP Labels, and MIP Label Policies.

.EXAMPLE
.\Export_MIP_Config.ps1 -Action "AIP Service Configuration" -ExportPath "C:\exports"

.EXAMPLE
.\Export_MIP_Config.ps1 -Action "MIP Labels" -ExportPath "C:\exports" -UPN "user@example.com"
#>

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("AIP Service Configuration", "IRM Configuration", "MIP Labels", "MIP Label Policies", "Document Tracking Status")]
    [string]$Action,

    [Parameter(Mandatory=$true)]
    [string]$ExportPath,

    [Parameter(Mandatory=$false)]
    [string]$UPN
)

function Export-AIPServiceConfiguration {
    # Import the AIPService module
    Import-Module AIPService
    
    # Connect to the AIP Service
    Connect-AipService

    # Get the AIP Service Configuration and export to the specified path
    $config = Get-AipServiceConfiguration
    $config | Out-File -Path "$ExportPath\AIPServiceConfiguration.txt"

    Write-Output "Exported AIP Service Configuration to $ExportPath\AIPServiceConfiguration.txt"
}

function Export-IRMConfiguration {
    # Import the ExchangeOnlineManagement module
    Import-Module ExchangeOnlineManagement
    
    # Connect to Exchange Online with the provided UPN
    Connect-ExchangeOnline -UserPrincipalName $UPN

    # Get the IRM Configuration and export to the specified path using Format-List (fl)
    $config = Get-IRMConfiguration | Format-List | Out-String
    Set-Content -Path "$ExportPath\IRMConfiguration.txt" -Value $config

    Write-Output "Exported IRM Configuration for $UPN to $ExportPath\IRMConfiguration.txt"
}

function Export-MIPLabels {
    # Import the ExchangeOnlineManagement module
    Import-Module ExchangeOnlineManagement
    
    # Connect to the IP Protection Service (IPP) session with the provided UPN
    Connect-IPPSSession -UserPrincipalName $UPN

    # Get the MIP Labels and export to the specified path using Format-List (fl)
    $labels = Get-Label | Format-List | Out-String
    Set-Content -Path "$ExportPath\MIPLabels.txt" -Value $labels

    Write-Output "Exported MIP Labels for $UPN to $ExportPath\MIPLabels.txt"
}

function Export-MIPLabelPolicies {
    # Import the ExchangeOnlineManagement module
    Import-Module ExchangeOnlineManagement
    
    # Connect to the IP Protection Service (IPP) session with the provided UPN
    Connect-IPPSSession -UserPrincipalName $UPN

    # Get the MIP Label Policies and export to the specified path using Format-List (fl)
    $labelPolicies = Get-LabelPolicy | Format-List | Out-String
    Set-Content -Path "$ExportPath\MIPLabelPolicies.txt" -Value $labelPolicies

    Write-Output "Exported MIP Label Policies for $UPN to $ExportPath\MIPLabelPolicies.txt"
}

function Export-DocumentTrackingStatus {
    # Import the AIPService module
    Import-Module AIPService

    # Connect to the AIP Service
    Connect-AipService

    # Get the Document Tracking Status and export to the specified path
    $trackingStatus = Get-AipServiceDocumentTrackingFeature | Format-List | Out-String
    Set-Content -Path "$ExportPath\DocumentTrackingStatus.txt" -Value $trackingStatus

    Write-Output "Exported Document Tracking Status to $ExportPath\DocumentTrackingStatus.txt"
}

# Main script logic
switch ($Action) {
    "AIP Service Configuration" {
        Export-AIPServiceConfiguration
    }
    "IRM Configuration" {
        if (-not $UPN) {
            Write-Error "UPN is required for exporting IRM Configuration."
            exit 1
        }
        Export-IRMConfiguration
    }
    "MIP Labels" {
        if (-not $UPN) {
            Write-Error "UPN is required for exporting MIP Labels."
            exit 1
        }
        Export-MIPLabels
    }
    "MIP Label Policies" {
        if (-not $UPN) {
            Write-Error "UPN is required for exporting MIP Label Policies."
            exit 1
        }
        Export-MIPLabelPolicies
    }
    "Document Tracking Status" {
        Export-DocumentTrackingStatus
    }
}