<#
.SYNOPSIS
    This script updates retention policies in Microsoft 365 Purview based on the information provided in a CSV file.

.DESCRIPTION
    The script connects to the Security & Compliance PowerShell, reads retention policy details from a CSV file, 
    and updates retention policies in Microsoft 365 Purview. The CSV file should contain columns for PolicyName, 
    RetentionDurationDays, and RetentionComplianceAction.

.PARAMETER csvPath
    The path to the CSV file containing the retention policy details.

.PARAMETER adminUPN
    The User Principal Name (UPN) of the admin account used to connect to Security & Compliance PowerShell.

.EXAMPLE
    .\New-RetentionPolicyRule.ps1 -csvPath "C:\Path\To\Your\CSV\rules.csv" -adminUPN "admin@yourdomain.onmicrosoft.com"

.NOTES
    Ensure you have the necessary permissions to update retention policies and connect to the Security & Compliance PowerShell.
#>

param (
    [string]$csvPath = "C:\Path\To\Your\CSV\rules.csv",
    [string]$adminUPN
)

# Connect to Security & Compliance PowerShell
Connect-ExchangeOnline -UserPrincipalName $adminUPN

# Import the CSV file
$policies = Import-Csv -Path $csvPath

# Loop through each policy and update it
foreach ($policy in $policies) {
    $policyName = $policy.PolicyName
    $retentionDurationDays = $policy.RetentionDurationDays
    $retentionComplianceAction = $policy.RetentionComplianceAction

    # Update the retention policy with the retention duration and compliance action
    New-RetentionComplianceRule -Policy $policyName `
        -RetentionDuration $retentionDurationDays `
        -RetentionComplianceAction $retentionComplianceAction

    Write-Output "Retention policy '$policyName' updated with retention duration of $retentionDurationDays days and action '$retentionComplianceAction'."
}

# Disconnect from Security & Compliance PowerShell
Disconnect-ExchangeOnline -Confirm:$false