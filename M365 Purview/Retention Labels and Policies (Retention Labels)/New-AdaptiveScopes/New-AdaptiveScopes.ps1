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
.\New-AdaptiveScopes.ps1 -CsvPath "C:\path\to\scopes.csv" -AdminAccount "admin@domain.com"

.NOTES
Ensure that the Exchange Online Management module is installed and that you have the necessary permissions to create adaptive scopes.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$CsvPath = $env:CSV_PATH,

    [Parameter(Mandatory=$true)]
    [string]$AdminAccount = $env:ADMIN_ACCOUNT
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
    Connect-IPPSSession -UserPrincipalName $AdminAccount
} catch {
    Write-Error "Failed to connect to Security & Compliance Center: $_"
    exit 1
}

try {
    $scopes = Import-Csv -Path $CsvPath
} catch {
    Write-Error "Failed to import CSV file: $_"
    exit 1
}

foreach ($scope in $scopes) {
    try {
        $rawQuery = $scope.Query
        New-AdaptiveScope -Name $scope.Name -LocationType $scope.Location -RawQuery $rawQuery
    } catch {
        Write-Error "Failed to create adaptive scope for $($scope.Name): $_"
    }
}

try {
    Disconnect-ExchangeOnline
} catch {
    Write-Error "Failed to disconnect from Security & Compliance Center: $_"
}