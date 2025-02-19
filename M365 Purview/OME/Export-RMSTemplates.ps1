<#
.SYNOPSIS
This script exports all RMS templates in the environment.

.DESCRIPTION
The script imports the ExchangeOnlineManagement module, connects to the IPPS session using the provided UPN, and retrieves the RMS templates.

.INSTRUCTIONS
1. Ensure you have the necessary permissions to export RMS templates.
2. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
3. Run the script using the provided examples or your own parameters.

.PERMISSIONS NEEDED
- Security Admin or greater (confirmed)

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETERS
-UPN: The User Principal Name (UPN) for administrative actions.

.EXAMPLES
.\Export-RMSTemplates.ps1 -UPN "yourupn@domain.com"

.NOTES
- Ensure the ExchangeOnlineManagement module is installed.
- Cmdlets will be downloaded when the session is active.
- Security permissions need to be active first. If the user is not an admin, the command will fail to execute without giving a permission error.
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
    # Connect to IPPS session using the provided UPN
    Connect-IPPSSession -UserPrincipalName $UPN -ErrorAction Stop
} catch {
    Write-Error "Failed to connect to IPPS session: $_"
    exit 1
}

try {
    # Start transcript
    Start-Transcript -Path "$env:TEMP\Export-RMSTemplates.log" -ErrorAction Stop

    # Get RMS templates and export to the specified path
    $templates = Get-RMSTemplate | Format-List | Out-String
    Set-Content -Path "$env:TEMP\RMSTemplates.txt" -Value $templates

    Write-Output "RMS templates have been successfully exported to $env:TEMP\RMSTemplates.txt"

    # Stop transcript
    Stop-Transcript -ErrorAction Stop
} catch {
    Write-Error "Failed to export RMS templates: $_"
    exit 1
}