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
