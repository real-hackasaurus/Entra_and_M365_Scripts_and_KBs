<#
.SYNOPSIS
Exports configurations for Microsoft Information Protection (MIP).

.DESCRIPTION
This script exports various configurations for MIP, including AIP Service Configuration, IRM Configuration, MIP Labels, MIP Label Policies, and Document Tracking Status.

.PARAMETER Action
Specifies which action to perform. Valid options are:
- AIP Service Configuration
- IRM Configuration
- MIP Labels
- MIP Label Policies
- Document Tracking Status

.PARAMETER ExportPath
Specifies the directory path where the exported information will be saved.

.PARAMETER UPN
User Principal Name required for exporting the IRM Configuration, MIP Labels, and MIP Label Policies.

.EXAMPLE
.\Export_MIP_Config.ps1 -Action "AIP Service Configuration" -ExportPath "C:\exports"

.EXAMPLE
.\Export_MIP_Config.ps1 -Action "MIP Labels" -ExportPath "C:\exports" -UPN "user@example.com"

.NOTES
Permissions: Ensure you have the necessary permissions to access and export the configurations.
Modules: AIPService, ExchangeOnlineManagement
#>

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("AIP Service Configuration", "IRM Configuration", "MIP Labels", "MIP Label Policies", "Document Tracking Status")]
    [string]$Action = $env:ACTION,

    [Parameter(Mandatory=$true)]
    [string]$ExportPath = $env:EXPORT_PATH,

    [Parameter(Mandatory=$false)]
    [string]$UPN = $env:UPN
)

function Check-Module {
    param (
        [string]$ModuleName
    )
    if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
        Install-Module -Name $ModuleName -Force -Scope CurrentUser
    }
    Import-Module $ModuleName -ErrorAction Stop
}

function Export-AIPServiceConfiguration {
    try {
        Check-Module -ModuleName "AIPService"
        Connect-AipService
        $config = Get-AipServiceConfiguration
        $config | Out-File -Path "$ExportPath\AIPServiceConfiguration.txt"
        Write-Output "Exported AIP Service Configuration to $ExportPath\AIPServiceConfiguration.txt"
    } catch {
        Write-Error "Failed to export AIP Service Configuration: $_"
    }
}

function Export-IRMConfiguration {
    try {
        Check-Module -ModuleName "ExchangeOnlineManagement"
        Connect-ExchangeOnline -UserPrincipalName $UPN
        $config = Get-IRMConfiguration | Format-List | Out-String
        Set-Content -Path "$ExportPath\IRMConfiguration.txt" -Value $config
        Write-Output "Exported IRM Configuration for $UPN to $ExportPath\IRMConfiguration.txt"
    } catch {
        Write-Error "Failed to export IRM Configuration: $_"
    }
}

function Export-MIPLabels {
    try {
        Check-Module -ModuleName "ExchangeOnlineManagement"
        Connect-IPPSSession -UserPrincipalName $UPN
        $labels = Get-Label | Format-List | Out-String
        Set-Content -Path "$ExportPath\MIPLabels.txt" -Value $labels
        Write-Output "Exported MIP Labels for $UPN to $ExportPath\MIPLabels.txt"
    } catch {
        Write-Error "Failed to export MIP Labels: $_"
    }
}

function Export-MIPLabelPolicies {
    try {
        Check-Module -ModuleName "ExchangeOnlineManagement"
        Connect-IPPSSession -UserPrincipalName $UPN
        $labelPolicies = Get-LabelPolicy | Format-List | Out-String
        Set-Content -Path "$ExportPath\MIPLabelPolicies.txt" -Value $labelPolicies
        Write-Output "Exported MIP Label Policies for $UPN to $ExportPath\MIPLabelPolicies.txt"
    } catch {
        Write-Error "Failed to export MIP Label Policies: $_"
    }
}

function Export-DocumentTrackingStatus {
    try {
        Check-Module -ModuleName "AIPService"
        Connect-AipService
        $trackingStatus = Get-AipServiceDocumentTrackingFeature | Format-List | Out-String
        Set-Content -Path "$ExportPath\DocumentTrackingStatus.txt" -Value $trackingStatus
        Write-Output "Exported Document Tracking Status to $ExportPath\DocumentTrackingStatus.txt"
    } catch {
        Write-Error "Failed to export Document Tracking Status: $_"
    }
}

# Main script logic
try {
    switch ($Action) {
        "AIP Service Configuration" {
            Export-AIPServiceConfiguration
        }
        "IRM Configuration" {
            if (-not $UPN) {
                throw "UPN is required for exporting IRM Configuration."
            }
            Export-IRMConfiguration
        }
        "MIP Labels" {
            if (-not $UPN) {
                throw "UPN is required for exporting MIP Labels."
            }
            Export-MIPLabels
        }
        "MIP Label Policies" {
            if (-not $UPN) {
                throw "UPN is required for exporting MIP Label Policies."
            }
            Export-MIPLabelPolicies
        }
        "Document Tracking Status" {
            Export-DocumentTrackingStatus
        }
        default {
            throw "Invalid action specified."
        }
    }
} catch {
    Write-Error "An error occurred: $_"
}