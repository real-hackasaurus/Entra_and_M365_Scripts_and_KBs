<#
.SYNOPSIS
This script enables the newer capabilities of PDFs, specifically auto-inherit permissions from the email for PDFs.

.DESCRIPTION
The script imports the ExchangeOnlineManagement module, connects to Exchange Online, and enables PDF encryption.

.INSTRUCTIONS
1. Ensure you have the necessary permissions to enable PDF encryption.
2. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
3. Run the script using the provided examples or your own parameters.

.PERMISSIONS
- Global Administrator: Set-IRMConfiguration
- Security Administrator: (Needs testing)

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETER UPN
The User Principal Name (UPN) for administrative actions.

.EXAMPLE
.\Enable-PDFLabeling.ps1 -UPN "admin@contoso.com"

.NOTES
File Name      : Enable-PDFLabeling.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
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
    # Enable PDF encryption
    Set-IRMConfiguration -EnablePdfEncryption $true -ErrorAction Stop
    Write-Output "PDF Encryption enabled successfully."
} catch {
    Write-Error "Failed to enable PDF Encryption: $_"
    exit 1
}