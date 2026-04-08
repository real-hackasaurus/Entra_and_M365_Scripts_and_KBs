<#
.SYNOPSIS
This script connects to the Security & Compliance Center and creates new adaptive scopes based on a CSV file.

.DESCRIPTION
This script imports the Exchange Online Management module, connects to the Security & Compliance Center, reads adaptive scope definitions from a CSV file, and creates new adaptive scopes based on the CSV data.

.INSTRUCTIONS
1. Ensure you have the ExchangeOnlineManagement module installed.
2. Create a CSV file with columns: Name, Location, Query.
3. Update the $adminAccount variable with your admin UPN.
4. Update the $csvPath variable to point to your CSV file.
5. Run the script in PowerShell.

.PERMISSIONS
- Global Administrator or Compliance Administrator

.MODULES NEEDED
- ExchangeOnlineManagement

.EXAMPLE
.\New-AdaptiveScopes.ps1

This will read adaptive scope definitions from the CSV file and create them in the Security & Compliance Center.

.NOTES
File Name      : New-AdaptiveScopes.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

# Install the Exchange Online Management module if not already installed
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
}

# Import the module
Import-Module ExchangeOnlineManagement

# Define the admin account to connect
$adminAccount = "admin@M365x34890247.onmicrosoft.com"

# Connect to the Security & Compliance Center
Connect-IPPSSession -UserPrincipalName $adminAccount

# Define the path to the CSV file
$csvPath = "C:\Users\wesle\OneDrive\Documents\GitHub\Azure_and_O365_Scripts_and_KBs\Test\Add and Remove Purview Adaptive Scopes\scopes.csv"

# Import the CSV file
$scopes = Import-Csv -Path $csvPath

# Loop through each row in the CSV and create adaptive scopes
foreach ($scope in $scopes) {
    $rawQuery = $scope.Query
    New-AdaptiveScope -Name $scope.Name -LocationType $scope.Location -RawQuery $rawQuery
}

# Disconnect from the Security & Compliance Center
#Disconnect-ExchangeOnline
