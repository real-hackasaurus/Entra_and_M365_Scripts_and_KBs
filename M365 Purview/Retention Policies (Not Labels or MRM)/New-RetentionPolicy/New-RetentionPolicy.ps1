<#
.SYNOPSIS
    This script creates new retention policies in Microsoft 365 Purview based on the information provided in a CSV file.

.DESCRIPTION
    The script connects to the Security & Compliance PowerShell, reads retention policy details from a CSV file, 
    and creates new retention policies in Microsoft 365 Purview. The CSV file should contain columns for PolicyName, 
    ExchangeLocation, SharePointLocation, and OneDriveLocation.

.PARAMETER csvPath
    The path to the CSV file containing the retention policy details.

.PARAMETER adminUPN
    The User Principal Name (UPN) of the admin account used to connect to Security & Compliance PowerShell.

.EXAMPLE
    .\New-RetentionPolicy.ps1 -csvPath "C:\Path\To\Your\CSV\policies.csv" -adminUPN "admin@yourdomain.onmicrosoft.com"

.NOTES
    Ensure you have the necessary permissions to create retention policies and connect to the Security & Compliance PowerShell.

.PERMISSIONS
    Ensure you have the necessary permissions to create retention policies and connect to the Security & Compliance PowerShell.

.MODULES
    ExchangeOnlineManagement

#>

param (
    [string]$csvPath = $env:CSV_PATH,
    [string]$adminUPN = $env:ADMIN_UPN
)

# Check if necessary modules are installed
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Force -Scope CurrentUser
}
Import-Module ExchangeOnlineManagement

try {
    # Validate parameters
    if (-not $csvPath) {
        throw "CSV path is required."
    }
    if (-not $adminUPN) {
        throw "Admin UPN is required."
    }

    # Connect to Security & Compliance PowerShell
    Connect-ExchangeOnline -UserPrincipalName $adminUPN

    # Import the CSV file
    $policies = Import-Csv -Path $csvPath

    # Loop through each policy and create it
    foreach ($policy in $policies) {
        $policyName = $policy.PolicyName
        $exchangeLocation = $policy.ExchangeLocation
        $sharePointLocation = $policy.SharePointLocation
        $oneDriveLocation = $policy.OneDriveLocation

        # Build the command dynamically based on available locations
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

        # Execute the command
        try {
            Invoke-Expression $command
            Write-Output "Retention policy '$policyName' created successfully."
        } catch {
            Write-Error "Failed to create retention policy '$policyName': $_"
        }
    }

    # Disconnect from Security & Compliance PowerShell
    Disconnect-ExchangeOnline -Confirm:$false
} catch {
    Write-Error "An error occurred: $_"
}