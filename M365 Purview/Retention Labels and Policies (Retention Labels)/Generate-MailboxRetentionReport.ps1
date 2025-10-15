<#
.SYNOPSIS
    This script generates a detailed retention report for a specified mailbox in Microsoft 365 (Exchange Online).

.DESCRIPTION
    This script connects to Exchange Online and Microsoft Purview (Compliance Center) to retrieve information about:
    - Organization-wide retention policies
    - Retention policies applied to the mailbox
    - Retention labels and label policies
    - MRM (Messaging Records Management) retention policies
    - eDiscovery and In-Place Holds
    - Retention Hold and Delay Hold status

    The script outputs the results to a text file named "RetentionReport.txt" in the current working directory.

.PARAMETER AdminAccount
    The admin account to use for connecting to Exchange Online and the Compliance Center.

.PARAMETER MailboxIdentity
    The identity of the mailbox to generate the retention report for.

.EXAMPLE
    .\Generate-MailboxRetentionReport.ps1 -AdminAccount "admin@M365x34890247.onmicrosoft.com" -MailboxIdentity "admin@M365x34890247.onmicrosoft.com"

.NOTES
    Permissions: Ensure you have the necessary permissions to access and export the configurations.
    Modules: ExchangeOnlineManagement
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$AdminAccount = $env:ADMIN_ACCOUNT,

    [Parameter(Mandatory=$true)]
    [string]$MailboxIdentity = $env:MAILBOX_IDENTITY
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

function Connect-Exchange {
    param (
        [string]$AdminAccount
    )
    try {
        Connect-ExchangeOnline -UserPrincipalName $AdminAccount -ShowProgress $true
        Connect-IPPSSession -UserPrincipalName $AdminAccount
    } catch {
        Write-Error "Failed to connect to Exchange Online or Compliance Center: $_"
        exit 1
    }
}

try {
    Check-Module -ModuleName "ExchangeOnlineManagement"
} catch {
    Write-Error "Failed to install or import ExchangeOnlineManagement module: $_"
    exit 1
}

# Check if ExchangeOnlineManagement module is installed and imported
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Force
}
Import-Module ExchangeOnlineManagement

Connect-Exchange -AdminAccount $AdminAccount

# Output file
$outputFile = "RetentionReport.txt"

# Clear the output file if it exists
if (Test-Path $outputFile) {
    Clear-Content $outputFile
}

# Write header to the output file
"============================================================" | Out-File -FilePath $outputFile
"Retention Report for Mailbox: $MailboxIdentity" | Out-File -FilePath $outputFile -Append
"Generated on: $(Get-Date)" | Out-File -FilePath $outputFile -Append
"============================================================" | Out-File -FilePath $outputFile -Append
"" | Out-File -FilePath $outputFile -Append

function Get-MailboxBasicInfo {
    param (
        [string]$MailboxIdentity,
        [string]$OutputFile
    )
    try {
        "===================== Mailbox Basic Information =====================" | Out-File -FilePath $OutputFile -Append
        $mailbox = Get-Mailbox -Identity $MailboxIdentity
        "Primary SMTP Address: $($mailbox.PrimarySmtpAddress)" | Out-File -FilePath $OutputFile -Append
        "Display Name: $($mailbox.DisplayName)" | Out-File -FilePath $OutputFile -Append
        "Mailbox Type: $($mailbox.RecipientTypeDetails)" | Out-File -FilePath $OutputFile -Append
        "Mailbox Size: $($mailbox.TotalItemSize)" | Out-File -FilePath $OutputFile -Append
        "Litigation Hold Enabled: $($mailbox.LitigationHoldEnabled)" | Out-File -FilePath $OutputFile -Append
        "Retention Hold Enabled: $($mailbox.RetentionHoldEnabled)" | Out-File -FilePath $OutputFile -Append
        "" | Out-File -FilePath $OutputFile -Append
    } catch {
        Write-Error "Failed to get mailbox basic information: $_"
    }
}

Get-MailboxBasicInfo -MailboxIdentity $MailboxIdentity -OutputFile $outputFile

function Get-OrgRetentionPolicies {
    param (
        [string]$OutputFile
    )
    try {
        "===================== Organization-Wide Retention Policies =====================" | Out-File -FilePath $OutputFile -Append
        "Organization-wide holds are applied when the location setting for the policy is set to 'All' for any of the workloads (Exchange, SharePoint, OneDrive, etc.)." | Out-File -FilePath $OutputFile -Append
        "These holds ensure that data across the entire organization is retained according to the specified policy." | Out-File -FilePath $OutputFile -Append
        "For more information, see: https://learn.microsoft.com/en-us/purview/ediscovery-identify-a-hold-on-an-exchange-online-mailbox" | Out-File -FilePath $OutputFile -Append
        "" | Out-File -FilePath $OutputFile -Append

        $orgConfig = Get-OrganizationConfig
        $inPlaceHolds = $orgConfig.InPlaceHolds

        if ($inPlaceHolds) {
            "In-Place Holds (Organization-Wide):" | Out-File -FilePath $OutputFile -Append
            foreach ($hold in $inPlaceHolds) {
                $cleanGuid = $hold -replace '^mbx', '' -replace ':\d+$', ''
                $policy = Get-RetentionCompliancePolicy -Identity $cleanGuid -DistributionDetail -ErrorAction SilentlyContinue

                if ($policy) {
                    "GUID: $cleanGuid" | Out-File -FilePath $OutputFile -Append
                    "Policy Name: $($policy.Name)" | Out-File -FilePath $OutputFile -Append
                    "Policy Type: $($policy.Type)" | Out-File -FilePath $OutputFile -Append
                    "Policy Enabled: $($policy.Enabled)" | Out-File -FilePath $OutputFile -Append
                    "Policy Mode: $($policy.Mode)" | Out-File -FilePath $OutputFile -Append
                    "" | Out-File -FilePath $OutputFile -Append
                } else {
                    "GUID: $cleanGuid (No policy details found)" | Out-File -FilePath $OutputFile -Append
                }
            }
        } else {
            "No organization-wide in-place holds found." | Out-File -FilePath $OutputFile -Append
        }
        "" | Out-File -FilePath $OutputFile -Append
    } catch {
        Write-Error "Failed to get organization-wide retention policies: $_"
    }
}

Get-OrgRetentionPolicies -OutputFile $outputFile

function Get-RetentionPolicyDetails {
    param (
        [string]$PolicyName,
        [string]$MailboxIdentity,
        [string]$OutputFile
    )
    try {
        "===================== Retention Policy Details =====================" | Out-File -FilePath $OutputFile -Append
        "Retention policies are location-based holds placed on specific workloads (e.g., Exchange, SharePoint, OneDrive)." | Out-File -FilePath $OutputFile -Append
        "These policies ensure that data in the specified locations is retained or deleted according to the policy rules." | Out-File -FilePath $OutputFile -Append
        "For more information, see: https://learn.microsoft.com/en-us/purview/ediscovery-identify-a-hold-on-an-exchange-online-mailbox" | Out-File -FilePath $OutputFile -Append
        "" | Out-File -FilePath $OutputFile -Append

        "In-Place Hold Details for Mailbox: $MailboxIdentity" | Out-File -FilePath $OutputFile -Append
        Get-Mailbox $MailboxIdentity | FL LitigationHoldEnabled, InPlaceHolds | Out-File -FilePath $OutputFile -Append

        $inPlaceHolds = Get-Mailbox $MailboxIdentity | Select-Object -ExpandProperty InPlaceHolds
        if ($inPlaceHolds) {
            foreach ($hold in $inPlaceHolds) {
                $cleanGuid = $hold -replace '^mbx', '' -replace ':\d+$', ''
                $policy = Get-RetentionCompliancePolicy $cleanGuid -DistributionDetail
                if ($policy) {
                    "Policy Details for GUID: $cleanGuid" | Out-File -FilePath $OutputFile -Append
                    "Policy Name: $($policy.Name)" | Out-File -FilePath $OutputFile -Append
                    "Policy Type: $($policy.Type)" | Out-File -FilePath $OutputFile -Append
                    "Policy Enabled: $($policy.Enabled)" | Out-File -FilePath $OutputFile -Append
                    "Policy Mode: $($policy.Mode)" | Out-File -FilePath $OutputFile -Append
                }
            }
        }
        "" | Out-File -FilePath $OutputFile -Append
    } catch {
        Write-Error "Failed to get retention policy details: $_"
    }
}

Get-RetentionPolicyDetails -PolicyName "Capstone" -MailboxIdentity $MailboxIdentity -OutputFile $outputFile

function Get-eDiscoveryDetails {
    param (
        [string]$CaseHoldGuid,
        [string]$OutputFile
    )
    try {
        "===================== eDiscovery and In-Place Holds =====================" | Out-File -FilePath $OutputFile -Append
        "eDiscovery holds are used to preserve data for legal or investigative purposes." | Out-File -FilePath $OutputFile -Append
        "In-Place Holds are a legacy feature that has been replaced by Retention Policies and eDiscovery Holds." | Out-File -FilePath $OutputFile -Append
        "" | Out-File -FilePath $OutputFile -Append

        if ($CaseHoldGuid) {
            $CaseHold = Get-CaseHoldPolicy $CaseHoldGuid
            "eDiscovery Case Hold Details for GUID: $CaseHoldGuid" | Out-File -FilePath $OutputFile -Append
            Get-ComplianceCase $CaseHold.CaseId | FL Name | Out-File -FilePath $OutputFile -Append
            $CaseHold | FL Name, ExchangeLocation | Out-File -FilePath $OutputFile -Append
        } else {
            "No Case Hold GUID provided." | Out-File -FilePath $OutputFile -Append
        }
        "" | Out-File -FilePath $OutputFile -Append
    } catch {
        Write-Error "Failed to get eDiscovery details: $_"
    }
}

# Example usage:
# Get-eDiscoveryDetails -CaseHoldGuid "f491b6ff-5f74-43d6-b2f1-4269512c7211" -OutputFile $outputFile

function Get-RetentionHoldStatus {
    param (
        [string]$MailboxIdentity,
        [string]$OutputFile
    )
    try {
        "===================== Retention Hold Status =====================" | Out-File -FilePath $OutputFile -Append
        "A Retention Hold suspends the processing of an MRM retention policy by the Managed Folder Assistant for the specified mailbox." | Out-File -FilePath $OutputFile -Append
        "This is useful when a user is on vacation or temporarily unable to manage their mailbox." | Out-File -FilePath $OutputFile -Append
        "For more information, see: https://learn.microsoft.com/en-us/purview/ediscovery-identify-a-hold-on-an-exchange-online-mailbox" | Out-File -FilePath $OutputFile -Append
        "" | Out-File -FilePath $OutputFile -Append

        $retentionHoldEnabled = Get-Mailbox $MailboxIdentity | Select-Object -ExpandProperty RetentionHoldEnabled
        "Retention Hold Enabled: $retentionHoldEnabled" | Out-File -FilePath $OutputFile -Append
        "" | Out-File -FilePath $OutputFile -Append
    } catch {
        Write-Error "Failed to get retention hold status: $_"
    }
}

Get-RetentionHoldStatus -MailboxIdentity $MailboxIdentity -OutputFile $outputFile

function Get-DelayHoldStatus {
    param (
        [string]$MailboxIdentity,
        [string]$OutputFile
    )
    try {
        "===================== Delay Hold Status =====================" | Out-File -FilePath $OutputFile -Append
        "A Delay Hold means that the actual removal of a hold is delayed for 30 days to prevent data from being permanently deleted (purged) from the mailbox." | Out-File -FilePath $OutputFile -Append
        "This ensures that data is recoverable for a period after the hold is removed." | Out-File -FilePath $OutputFile -Append
        "For more information, see: https://learn.microsoft.com/en-us/purview/ediscovery-identify-a-hold-on-an-exchange-online-mailbox" | Out-File -FilePath $OutputFile -Append
        "" | Out-File -FilePath $OutputFile -Append

        "Delay Hold Status for Mailbox: $MailboxIdentity" | Out-File -FilePath $OutputFile -Append
        Get-Mailbox $MailboxIdentity | FL DelayHoldApplied, DelayReleaseHoldApplied | Out-File -FilePath $OutputFile -Append
        "" | Out-File -FilePath $OutputFile -Append
    } catch {
        Write-Error "Failed to get delay hold status: $_"
    }
}

Get-DelayHoldStatus -MailboxIdentity $MailboxIdentity -OutputFile $outputFile

function Get-RetentionLabelDetails {
    param (
        [string]$MailboxIdentity,
        [string]$OutputFile
    )
    try {
        "===================== Retention Label Policies =====================" | Out-File -FilePath $OutputFile -Append
        "Retention Labels allow you to classify and apply retention settings to individual items or folders." | Out-File -FilePath $OutputFile -Append
        "These labels can be applied manually or automatically based on conditions." | Out-File -FilePath $OutputFile -Append
        "" | Out-File -FilePath $OutputFile -Append

        "All Retention Labels in Purview" | Out-File -FilePath $OutputFile -Append
        Get-ComplianceTag | Format-Table -Auto Name, Priority, RetentionAction, RetentionDuration, Workload | Out-File -FilePath $OutputFile -Append

        "Details for Retention Label: Capstone Test" | Out-File -FilePath $OutputFile -Append
        Get-ComplianceTag -Identity "Capstone Test" | Out-File -FilePath $OutputFile -Append

        "Retention Label Status for Mailbox: $MailboxIdentity" | Out-File -FilePath $OutputFile -Append
        Get-Mailbox $MailboxIdentity | FL ComplianceTagHoldApplied | Out-File -FilePath $OutputFile -Append
        "" | Out-File -FilePath $OutputFile -Append
    } catch {
        Write-Error "Failed to get retention label details: $_"
    }
}

$IncludeRetentionLabelDetails = $false  # Set to $true to include Retention Label Policies details

if ($IncludeRetentionLabelDetails) {
    Get-RetentionLabelDetails -MailboxIdentity $MailboxIdentity -OutputFile $outputFile
}

function Get-MRMRetentionDetails {
    param (
        [string]$MailboxIdentity,
        [string]$OutputFile
    )
    try {
        "===================== MRM Retention Policies =====================" | Out-File -FilePath $OutputFile -Append
        "MRM (Messaging Records Management) Retention Policies are used to manage the lifecycle of email items in Exchange Online." | Out-File -FilePath $OutputFile -Append
        "These policies define how long items are retained and what action is taken when the retention period expires." | Out-File -FilePath $OutputFile -Append
        "" | Out-File -FilePath $OutputFile -Append

        "MRM Retention Policy Details" | Out-File -FilePath $OutputFile -Append
        $retentionPolicy = Get-RetentionPolicy -Identity "Default MRM Policy" | Format-List | Out-File -FilePath $OutputFile -Append

        "MRM Retention Tag Details: 1 Month Delete" | Out-File -FilePath $OutputFile -Append
        Get-RetentionPolicyTag "1 Month Delete" | Out-File -FilePath $OutputFile -Append

        "MRM Retention Policy Status for Mailbox: $MailboxIdentity" | Out-File -FilePath $OutputFile -Append
        if ($retentionPolicy) {
            $retentionPolicyTags = Get-RetentionPolicyTag | Where-Object { $_.RetentionPolicy -eq $retentionPolicy }
            "Retention Policy Tags for Mailbox: $MailboxIdentity" | Out-File -FilePath $OutputFile -Append
            $retentionPolicyTags | ForEach-Object {
                "  - $($_.Name): Type=$($_.Type), AgeLimitForRetention=$($_.AgeLimitForRetention), RetentionAction=$($_.RetentionAction)" | Out-File -FilePath $OutputFile -Append
            }
        } else {
            "No retention policy applied to this mailbox." | Out-File -FilePath $OutputFile -Append
        }
        "" | Out-File -FilePath $OutputFile -Append
    } catch {
        Write-Error "Failed to get MRM retention details: $_"
    }
}

$IncludeMRMRetentionDetails = $false  # Set to $true to include MRM Retention Policies details

if ($IncludeMRMRetentionDetails) {
    Get-MRMRetentionDetails -MailboxIdentity $MailboxIdentity -OutputFile $outputFile
}

function Get-RetentionPolicyDetails {
    param (
        [string]$MailboxIdentity,
        [string]$OutputFile
    )
    try {
        "===================== Retention Policy Details =====================" | Out-File -FilePath $OutputFile -Append
        "This section provides detailed information about retention policies applied to the mailbox." | Out-File -FilePath $OutputFile -Append
        "For more information, see: https://learn.microsoft.com/en-us/purview/ediscovery-identify-a-hold-on-an-exchange-online-mailbox" | Out-File -FilePath $OutputFile -Append
        "" | Out-File -FilePath $OutputFile -Append

        $inPlaceHolds = Get-Mailbox $MailboxIdentity | Select-Object -ExpandProperty InPlaceHolds

        if ($inPlaceHolds) {
            foreach ($hold in $inPlaceHolds) {
                $cleanGuid = $hold -replace '^mbx', '' -replace ':\d+$', ''
                $policy = Get-RetentionCompliancePolicy -Identity $cleanGuid -DistributionDetail -ErrorAction SilentlyContinue

                if ($policy) {
                    "Policy Details for GUID: $cleanGuid" | Out-File -FilePath $OutputFile -Append
                    "Policy Name: $($policy.Name)" | Out-File -FilePath $OutputFile -Append
                    "Policy Type: $($policy.Type)" | Out-File -FilePath $OutputFile -Append
                    "Policy Enabled: $($policy.Enabled)" | Out-File -FilePath $OutputFile -Append
                    "Policy Mode: $($policy.Mode)" | Out-File -FilePath $OutputFile -Append
                    "Policy Locations: $($policy.WorkloadLocations)" | Out-File -FilePath $OutputFile -Append
                    "" | Out-File -FilePath $OutputFile -Append
                } else {
                    "GUID: $cleanGuid (No policy details found)" | Out-File -FilePath $OutputFile -Append
                }
            }
        } else {
            "No retention policies found for this mailbox." | Out-File -FilePath $OutputFile -Append
        }
        "" | Out-File -FilePath $OutputFile -Append
    } catch {
        Write-Error "Failed to get retention policy details: $_"
    }
}

$IncludeRetentionPolicyDetails = $false  # Set to $true to include Retention Policy details

if ($IncludeRetentionPolicyDetails) {
    Get-RetentionPolicyDetails -MailboxIdentity $MailboxIdentity -OutputFile $outputFile
}

Write-Host "Retention report generated at: $outputFile"