<#
.SYNOPSIS
    Display the active IRM settings, useful for troubleshooting MIP.

.DESCRIPTION
    The script imports the ExchangeOnlineManagement module, connects to Exchange Online, and retrieves the IRM configuration.

.PARAMETER UPN
    The User Principal Name (UPN) for administrative actions.

.EXAMPLE
    .\Get-IRMConfiguration.ps1 -UPN "user@yourdomain.com"

.NOTES
    Author: Wesley Blackwell
    Date: 5/25/2022
    Prerequisite: ExchangeOnlineManagement module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$UPN = $env:UPN
)

# Validate parameters
if (-not $UPN) {
    Write-Error "UPN parameter is required."
    exit 1
}

# Check if ExchangeOnlineManagement module is installed
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    try {
        Install-Module -Name ExchangeOnlineManagement -Force -ErrorAction Stop
    } catch {
        Write-Error "Failed to install ExchangeOnlineManagement module: $_"
        exit 1
    }
}

try {
    # Import ExchangeOnlineManagement module
    Import-Module ExchangeOnlineManagement -ErrorAction Stop
} catch {
    Write-Error "Failed to import ExchangeOnlineManagement module: $_"
    exit 1
}

try {
    # Connect to Exchange Online
    Connect-ExchangeOnline -UserPrincipalName $UPN -ErrorAction Stop
} catch {
    Write-Error "Failed to connect to Exchange Online: $_"
    exit 1
}

try {
    # Get IRM Configuration
    $irmConfig = Get-IRMConfiguration -ErrorAction Stop
    Write-Output "IRM Configuration:"
    Write-Output $irmConfig | Format-List | Out-String
} catch {
    Write-Error "Failed to retrieve IRM Configuration: $_"
    exit 1
}