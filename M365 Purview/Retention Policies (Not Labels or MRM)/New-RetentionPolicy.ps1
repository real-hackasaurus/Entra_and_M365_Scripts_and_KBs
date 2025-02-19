<#
.SYNOPSIS
    Create new retention policies in Microsoft 365 Purview based on a CSV file.

.DESCRIPTION
    This script connects to the Security & Compliance PowerShell, reads retention policy details from a CSV file, and creates new retention policies in Microsoft 365 Purview.

.PARAMETER CsvPath
    The path to the CSV file containing the retention policy details.

.PARAMETER AdminUPN
    The User Principal Name (UPN) of the admin account used to connect to Security & Compliance PowerShell.

.EXAMPLE
    .\New-RetentionPolicy.ps1 -CsvPath "C:\Path\To\Your\CSV\policies.csv" -AdminUPN "admin@yourdomain.onmicrosoft.com"

.NOTES
    Author: Wesley Blackwell
    Date: 5/25/2022
    Prerequisite: ExchangeOnlineManagement module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$CsvPath = $env:CSV_PATH,

    [Parameter(Mandatory=$true)]
    [string]$AdminUPN = $env:ADMIN_UPN
)

function Check-Module {
    param (
        [string]$ModuleName
    )
    if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
        Install-Module -Name $ModuleName -Force -AllowClobber
    }
    Import-Module $ModuleName -ErrorAction Stop
}

# Check if ExchangeOnlineManagement module is installed and imported
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Force
}
Import-Module ExchangeOnlineManagement

try {
    Check-Module -ModuleName "ExchangeOnlineManagement"
} catch {
    Write-Error "Failed to install or import ExchangeOnlineManagement module: $_"
    exit 1
}

try {
    Connect-ExchangeOnline -UserPrincipalName $AdminUPN
} catch {
    Write-Error "Failed to connect to Security & Compliance PowerShell: $_"
    exit 1
}

try {
    $policies = Import-Csv -Path $CsvPath
} catch {
    Write-Error "Failed to import CSV file: $_"
    exit 1
}

foreach ($policy in $policies) {
    try {
        $policyName = $policy.PolicyName
        $exchangeLocation = $policy.ExchangeLocation
        $sharePointLocation = $policy.SharePointLocation
        $oneDriveLocation = $policy.OneDriveLocation

        $command = "New-RetentionCompliancePolicy -Name `"$policyName`"" 
        
        if ($exchangeLocation) {
            $command += " -ExchangeLocation `"$exchangeLocation`"" 
        }
        
        if ($sharePointLocation) {
            $command += " -SharePointLocation `"$sharePointLocation`"" 
        }
        
        if ($oneDriveLocation) {
            $command += " -OneDriveLocation `"$oneDriveLocation`"" 
        }

        Invoke-Expression $command
        Write-Output "Retention policy '$policyName' created successfully."
    } catch {
        Write-Error "Failed to create retention policy '$($policy.PolicyName)': $_"
    }
}

try {
    Disconnect-ExchangeOnline -Confirm:$false
} catch {
    Write-Error "Failed to disconnect from Security & Compliance PowerShell: $_"
}