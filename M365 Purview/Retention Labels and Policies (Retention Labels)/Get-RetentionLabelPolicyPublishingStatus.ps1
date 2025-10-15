<#
.SYNOPSIS
    Retrieve the publishing status of a specified retention label policy in Microsoft 365.

.DESCRIPTION
    This script connects to the Microsoft 365 Security & Compliance Center and retrieves information about the specified retention label policy.

.PARAMETER AdminAccount
    The admin account to use for connecting to the Microsoft 365 Security & Compliance Center.

.PARAMETER RetentionLabelPolicy
    The retention label policy to retrieve the publishing status for.

.EXAMPLE
    .\Get-RetentionLabelPolicyPublishingStatus.ps1 -AdminAccount "admin@yourdomain.com" -RetentionLabelPolicy "YourRetentionLabelPolicy"

.NOTES
    Author: Wesley Blackwell
    Date: 5/25/2022
    Prerequisite: ExchangeOnlineManagement module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$AdminAccount = $env:ADMIN_ACCOUNT,

    [Parameter(Mandatory=$true)]
    [string]$RetentionLabelPolicy = $env:RETENTION_LABEL_POLICY
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

# Check if ExchangeOnlineManagement module is installed and imported
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Force
}
Import-Module ExchangeOnlineManagement

try {
    Check-Module -ModuleName "ExchangeOnlineManagement"
} catch {
    Write-Error "Failed to install or import ExchangeOnlineManagement module: $_"
    exit 1
}

try {
    Connect-IPPSSession -UserPrincipalName $AdminAccount
} catch {
    Write-Error "Failed to connect to Microsoft 365 Security & Compliance Center: $_"
    exit 1
}

try {
    $policy = Get-RetentionCompliancePolicy -Identity $RetentionLabelPolicy
    $policy | fl
} catch {
    Write-Error "Failed to retrieve retention label policy: $_"
}

try {
    Disconnect-ExchangeOnline
} catch {
    Write-Error "Failed to disconnect from Microsoft 365 Security & Compliance Center: $_"
}