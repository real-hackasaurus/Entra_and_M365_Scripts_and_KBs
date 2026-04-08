<#
.SYNOPSIS
Creates new retention policy rules in Microsoft 365 Purview based on a CSV file.

.DESCRIPTION
This script connects to the Security & Compliance PowerShell, reads retention policy rule details from a CSV file, and creates new retention policy rules in Microsoft 365 Purview.

.INSTRUCTIONS
1. Ensure you have the ExchangeOnlineManagement module installed.
2. Create a CSV file with columns: PolicyName, RetentionDurationDays, RetentionComplianceAction.
3. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
4. Run the script using the provided examples or your own parameters.

.PERMISSIONS
Ensure you have the necessary permissions to create retention policy rules and connect to the Security & Compliance PowerShell.

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETER CsvPath
The path to the CSV file containing the retention policy rule details.

.PARAMETER AdminUPN
The User Principal Name (UPN) of the admin account used to connect to Security & Compliance PowerShell.

.EXAMPLE
.\New-RetentionPolicyRule.ps1 -CsvPath "C:\Path\To\Your\CSV\rules.csv" -AdminUPN "admin@yourdomain.onmicrosoft.com"

.NOTES
File Name      : New-RetentionPolicyRule.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
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