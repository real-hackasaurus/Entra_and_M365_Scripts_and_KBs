<#
.SYNOPSIS
This script exports all Activity and Alert policies in the Security Portal.

.DESCRIPTION
Using the ExchangeOnlineManagement module, this script fetches all activity and protection alerts from the Security Portal and exports them to CSV files.

.INSTRUCTIONS
1. Ensure you have the ExchangeOnlineManagement module installed.
2. Connect to your Office 365 using the Connect-IPPSSession cmdlet.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
You need to have Global Admin permissions to see all alerts.

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETER AdminUserPrincipalName
The User Principal Name of the admin account to connect to Exchange Online Protection.

.PARAMETER ActivityAlertPath
The file path where the activity alerts CSV file will be saved.

.PARAMETER ProtectionAlertPath
The file path where the protection alerts CSV file will be saved.

.EXAMPLE
.\Export-M365DefenderAlertPolicies.ps1 -AdminUserPrincipalName "admin@contoso.onmicrosoft.com" -ActivityAlertPath "C:\Path\To\ActivityAlert.csv" -ProtectionAlertPath "C:\Path\To\ProtectionAlert.csv"

This will export all activity and protection alerts to the specified CSV files.

.NOTES
File Name      : Export-M365DefenderAlertPolicies.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

<#

    -Created by: Wesley Blackwell
    -Date last updated: 5/3/2022

    -Overview:
        This script is designed to export all Activity and Alert policies in the Security Portal.
    -Overview doc, Get-ActivityAlert: https://docs.microsoft.com/en-us/powershell/module/exchange/get-activityalert?view=exchange-ps
    -Overview doc, Get-ProtectionAlert: https://docs.microsoft.com/en-us/powershell/module/exchange/get-protectionalert?view=exchange-ps

    -Permissions Needed:
        -Global Admin (confirmed): Preferred since this user can see everything. 

    -Modules Needed:
        -ExchangeOnlineManagement

    -Notes:
        -Cmdlets will be downloaded when the session is active.
        -Security permissions need to be active first. If user is not an admin, the command will just fail to execute without giving a permission error.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$AdminUserPrincipalName = $env:ADMIN_USER_PRINCIPAL_NAME,

    [Parameter(Mandatory=$true)]
    [string]$ActivityAlertPath = $env:ACTIVITY_ALERT_PATH,

    [Parameter(Mandatory=$true)]
    [string]$ProtectionAlertPath = $env:PROTECTION_ALERT_PATH
)

# Ensure parameters are not empty
try {
    if (-not $AdminUserPrincipalName) {
        Write-Error "AdminUserPrincipalName parameter is empty or not set!"
        exit
    }

    if (-not $ActivityAlertPath) {
        Write-Error "ActivityAlertPath parameter is empty or not set!"
        exit
    }

    if (-not $ProtectionAlertPath) {
        Write-Error "ProtectionAlertPath parameter is empty or not set!"
        exit
    }
} catch {
    Write-Error "Error checking parameters: $_"
    exit
}

Import-Module ExchangeOnlineManagement

try {
    # Connect to Exchange Online Protection
    Connect-IPPSSession -UserPrincipalName $AdminUserPrincipalName
} catch {
    Write-Error "Failed to connect to Exchange Online Protection: $_"
    exit
}

try {
    # Export Activity Alerts
    Get-ActivityAlert | Export-Csv -Path $ActivityAlertPath -NoTypeInformation
} catch {
    Write-Error "Error exporting Activity Alerts: $_"
}

try {
    # Export Protection Alerts
    Get-ProtectionAlert | Export-Csv -Path $ProtectionAlertPath -NoTypeInformation
} catch {
    Write-Error "Error exporting Protection Alerts: $_"
}