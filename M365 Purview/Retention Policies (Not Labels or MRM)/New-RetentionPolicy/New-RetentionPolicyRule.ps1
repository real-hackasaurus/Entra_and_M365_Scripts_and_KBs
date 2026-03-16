<#
.SYNOPSIS
    Update retention policies in Microsoft 365 Purview based on a CSV file.

.DESCRIPTION
    This script connects to the Security & Compliance PowerShell, reads retention policy details from a CSV file, and updates retention policies in Microsoft 365 Purview.

.PARAMETER CsvPath
    The path to the CSV file containing the retention policy details.

.PARAMETER AdminUPN
    The User Principal Name (UPN) of the admin account used to connect to Security & Compliance PowerShell.

.EXAMPLE
    .\New-RetentionPolicyRule.ps1 -CsvPath "C:\Path\To\Your\CSV\rules.csv" -AdminUPN "admin@yourdomain.onmicrosoft.com"

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
        $retentionDurationDays = $policy.RetentionDurationDays
        $retentionComplianceAction = $policy.RetentionComplianceAction

        New-RetentionComplianceRule -Policy $policyName `
            -RetentionDuration $retentionDurationDays `
            -RetentionComplianceAction $retentionComplianceAction

        Write-Output "Retention policy '$policyName' updated with retention duration of $retentionDurationDays days and action '$retentionComplianceAction'."
    } catch {
        Write-Error "Failed to update retention policy '$($policy.PolicyName)': $_"
    }
}

try {
    Disconnect-ExchangeOnline -Confirm:$false
} catch {
    Write-Error "Failed to disconnect from Security & Compliance PowerShell: $_"
}