<#
.SYNOPSIS
This script connects to the Security & Compliance Center, imports a CSV file containing adaptive scope definitions, and creates new adaptive scopes based on the CSV data.

.DESCRIPTION
The script performs the following steps:
1. Installs and imports the Exchange Online Management module if not already installed.
2. Connects to the Security & Compliance Center using the provided admin account.
3. Imports a CSV file containing adaptive scope definitions.
4. Loops through each row in the CSV file and creates new adaptive scopes.
5. Disconnects from the Security & Compliance Center.

.PARAMETER CsvPath
The path to the CSV file containing the adaptive scope definitions. The CSV file should have the following columns: Name, Location, Query.

.PARAMETER AdminAccount
The admin account to use for connecting to the Security & Compliance Center.

.EXAMPLE
.\New-RetentionLabelPolicies.ps1 -CsvPath "C:\path\to\scopes.csv" -AdminAccount "admin@domain.com"

.NOTES
Ensure that the Exchange Online Management module is installed and that you have the necessary permissions to create adaptive scopes.
#>

param (
    [string]$CsvPath,
    [string]$AdminAccount
)

# Install the Exchange Online Management module if not already installed
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
}

# Import the module
Import-Module ExchangeOnlineManagement

# Connect to the Security & Compliance Center
Connect-IPPSSession -UserPrincipalName $AdminAccount

# Import the CSV file
$scopes = Import-Csv -Path $CsvPath

# Loop through each row in the CSV and create adaptive scopes
foreach ($scope in $scopes) {
    $rawQuery = $scope.Query
    New-AdaptiveScope -Name $scope.Name -LocationType $scope.Location -RawQuery $rawQuery
}

# Disconnect from the Security & Compliance Center
Disconnect-ExchangeOnline