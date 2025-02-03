<#
.SYNOPSIS
    This script generates a detailed retention report for a specified mailbox in Microsoft 365 (Exchange Online).
    It checks for various types of holds, retention policies, and compliance settings, and outputs the results to a text file.

.DESCRIPTION
    This script connects to Exchange Online and Microsoft Purview (Compliance Center) to retrieve information about:
    - Organization-wide retention policies
    - Retention policies applied to the mailbox
    - Retention labels and label policies
    - MRM (Messaging Records Management) retention policies
    - eDiscovery and In-Place Holds
    - Retention Hold and Delay Hold status

    The script outputs the results to a text file named "RetentionReport.txt" in the current working directory.

.PREREQUISITES
    1. Install the Exchange Online Management module:
       Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
    2. Ensure you have the necessary permissions to connect to Exchange Online and the Compliance Center.
    3. Replace the placeholder values (e.g., admin account, mailbox identity) with your actual values.

.INSTRUCTIONS
    1. Open PowerShell with administrative privileges.
    2. Run the script.
    3. The script will prompt you to connect to Exchange Online and the Compliance Center.
    4. After execution, the report will be saved as "RetentionReport.txt" in the current directory.

.NOTES
    - Optional sections (Retention Label Policies, MRM Retention Policies, Capstone Policy Details) can be enabled by setting the corresponding switches to $true.
    - For more information on holds and retention policies, refer to the Microsoft documentation:
      https://learn.microsoft.com/en-us/purview/ediscovery-identify-a-hold-on-an-exchange-online-mailbox

.AUTHOR
    Wes Blackwell
    Version: 1.0
    Date: 2/3/2025
#>

#region StartUp

Import-Module ExchangeOnlineManagement

function Connect-Exchange {
    param (
        [string]$adminAccount
    )
    Connect-ExchangeOnline -UserPrincipalName $adminAccount -ShowProgress $true
    Connect-IPPSSession -UserPrincipalName $adminAccount
}

$adminAccount = "admin@M365x34890247.onmicrosoft.com"  # Replace with your admin account
Connect-Exchange -adminAccount $adminAccount

# Mailbox to check for retention policies
$mailboxIdentity = "admin@M365x34890247.onmicrosoft.com"  # Replace with the mailbox you want to check

$mailbox = Get-Mailbox -Identity $mailboxIdentity

# Output file
$outputFile = "RetentionReport.txt"

# Clear the output file if it exists
if (Test-Path $outputFile) {
    Clear-Content $outputFile
}

# Write header to the output file
"============================================================" | Out-File -FilePath $outputFile
"Retention Report for Mailbox: $($mailbox.PrimarySmtpAddress)" | Out-File -FilePath $outputFile -Append
"Generated on: $(Get-Date)" | Out-File -FilePath $outputFile -Append
"============================================================" | Out-File -FilePath $outputFile -Append
"" | Out-File -FilePath $outputFile -Append

#endregion StartUp

#region Mailbox Basic Information

function Get-MailboxBasicInfo {
    param (
        [string]$mailboxIdentity,
        [string]$outputFile
    )
    
    "===================== Mailbox Basic Information =====================" | Out-File -FilePath $outputFile -Append
    $mailbox = Get-Mailbox -Identity $mailboxIdentity
    "Primary SMTP Address: $($mailbox.PrimarySmtpAddress)" | Out-File -FilePath $outputFile -Append
    "Display Name: $($mailbox.DisplayName)" | Out-File -FilePath $outputFile -Append
    "Mailbox Type: $($mailbox.RecipientTypeDetails)" | Out-File -FilePath $outputFile -Append
    "Mailbox Size: $($mailbox.TotalItemSize)" | Out-File -FilePath $outputFile -Append
    "Litigation Hold Enabled: $($mailbox.LitigationHoldEnabled)" | Out-File -FilePath $outputFile -Append
    "Retention Hold Enabled: $($mailbox.RetentionHoldEnabled)" | Out-File -FilePath $outputFile -Append
    "" | Out-File -FilePath $outputFile -Append
}

Get-MailboxBasicInfo -mailboxIdentity $mailboxIdentity -outputFile $outputFile

#endregion Mailbox Basic Information

#region Organization-Wide Retention Policies

function Get-OrgRetentionPolicies {
    param (
        [string]$outputFile
    )
    
    "===================== Organization-Wide Retention Policies =====================" | Out-File -FilePath $outputFile -Append
    "Organization-wide holds are applied when the location setting for the policy is set to 'All' for any of the workloads (Exchange, SharePoint, OneDrive, etc.)." | Out-File -FilePath $outputFile -Append
    "These holds ensure that data across the entire organization is retained according to the specified policy." | Out-File -FilePath $outputFile -Append
    "For more information, see: https://learn.microsoft.com/en-us/purview/ediscovery-identify-a-hold-on-an-exchange-online-mailbox" | Out-File -FilePath $outputFile -Append
    "" | Out-File -FilePath $outputFile -Append

    $orgConfig = Get-OrganizationConfig
    $inPlaceHolds = $orgConfig.InPlaceHolds

    if ($inPlaceHolds) {
        "In-Place Holds (Organization-Wide):" | Out-File -FilePath $outputFile -Append
        foreach ($hold in $inPlaceHolds) {
            # Clean the GUID by removing the "mbx" prefix and ":number" suffix
            $cleanGuid = $hold -replace '^mbx', '' -replace ':\d+$', ''
            
            # Fetch the policy details using the cleaned GUID
            $policy = Get-RetentionCompliancePolicy -Identity $cleanGuid -DistributionDetail -ErrorAction SilentlyContinue

            if ($policy) {
                "GUID: $cleanGuid" | Out-File -FilePath $outputFile -Append
                "Policy Name: $($policy.Name)" | Out-File -FilePath $outputFile -Append
                "Policy Type: $($policy.Type)" | Out-File -FilePath $outputFile -Append
                "Policy Enabled: $($policy.Enabled)" | Out-File -FilePath $outputFile -Append
                "Policy Mode: $($policy.Mode)" | Out-File -FilePath $outputFile -Append
                "" | Out-File -FilePath $outputFile -Append
            } else {
                "GUID: $cleanGuid (No policy details found)" | Out-File -FilePath $outputFile -Append
            }
        }
    } else {
        "No organization-wide in-place holds found." | Out-File -FilePath $outputFile -Append
    }
    "" | Out-File -FilePath $outputFile -Append
}

Get-OrgRetentionPolicies -outputFile $outputFile

#endregion Organization-Wide Retention Policies

#region Retention Policies

function Get-RetentionPolicyDetails {
    param (
        [string]$policyName,
        [string]$mailboxIdentity,
        [string]$outputFile
    )
    
    "===================== Retention Policy Details =====================" | Out-File -FilePath $outputFile -Append
    "Retention policies are location-based holds placed on specific workloads (e.g., Exchange, SharePoint, OneDrive)." | Out-File -FilePath $outputFile -Append
    "These policies ensure that data in the specified locations is retained or deleted according to the policy rules." | Out-File -FilePath $outputFile -Append
    "For more information, see: https://learn.microsoft.com/en-us/purview/ediscovery-identify-a-hold-on-an-exchange-online-mailbox" | Out-File -FilePath $outputFile -Append
    "" | Out-File -FilePath $outputFile -Append

    "In-Place Hold Details for Mailbox: $mailboxIdentity" | Out-File -FilePath $outputFile -Append
    Get-Mailbox $mailboxIdentity | FL LitigationHoldEnabled, InPlaceHolds | Out-File -FilePath $outputFile -Append

    # If there is a result in either of the two commands above, pass the GUID to find where it is applied
    $inPlaceHolds = Get-Mailbox $mailboxIdentity | Select-Object -ExpandProperty InPlaceHolds
    if ($inPlaceHolds) {
        foreach ($hold in $inPlaceHolds) {
            $cleanGuid = $hold -replace '^mbx', '' -replace ':\d+$', ''
            $policy = Get-RetentionCompliancePolicy $cleanGuid -DistributionDetail
            if ($policy) {
                "Policy Details for GUID: $cleanGuid" | Out-File -FilePath $outputFile -Append
                "Policy Name: $($policy.Name)" | Out-File -FilePath $outputFile -Append
                "Policy Type: $($policy.Type)" | Out-File -FilePath $outputFile -Append
                "Policy Enabled: $($policy.Enabled)" | Out-File -FilePath $outputFile -Append
                "Policy Mode: $($policy.Mode)" | Out-File -FilePath $outputFile -Append
            }
        }
    }
    "" | Out-File -FilePath $outputFile -Append
}

Get-RetentionPolicyDetails -policyName "Capstone" -mailboxIdentity $mailboxIdentity -outputFile $outputFile

#endregion Retention Policies

#region eDiscovery and In-Place Holds

function Get-eDiscoveryDetails {
    param (
        [string]$caseHoldGuid,
        [string]$outputFile
    )
    
    "===================== eDiscovery and In-Place Holds =====================" | Out-File -FilePath $outputFile -Append
    "eDiscovery holds are used to preserve data for legal or investigative purposes." | Out-File -FilePath $outputFile -Append
    "In-Place Holds are a legacy feature that has been replaced by Retention Policies and eDiscovery Holds." | Out-File -FilePath $outputFile -Append
    "" | Out-File -FilePath $outputFile -Append

    if ($caseHoldGuid) {
        $CaseHold = Get-CaseHoldPolicy $caseHoldGuid
        "eDiscovery Case Hold Details for GUID: $caseHoldGuid" | Out-File -FilePath $outputFile -Append
        Get-ComplianceCase $CaseHold.CaseId | FL Name | Out-File -FilePath $outputFile -Append
        $CaseHold | FL Name, ExchangeLocation | Out-File -FilePath $outputFile -Append
    } else {
        "No Case Hold GUID provided." | Out-File -FilePath $outputFile -Append
    }
    "" | Out-File -FilePath $outputFile -Append
}

# Example usage:
# Get-eDiscoveryDetails -caseHoldGuid "f491b6ff-5f74-43d6-b2f1-4269512c7211" -outputFile $outputFile

#endregion eDiscovery and In-Place Holds

#region Retention Hold

function Get-RetentionHoldStatus {
    param (
        [string]$mailboxIdentity,
        [string]$outputFile
    )
    
    "===================== Retention Hold Status =====================" | Out-File -FilePath $outputFile -Append
    "A Retention Hold suspends the processing of an MRM retention policy by the Managed Folder Assistant for the specified mailbox." | Out-File -FilePath $outputFile -Append
    "This is useful when a user is on vacation or temporarily unable to manage their mailbox." | Out-File -FilePath $outputFile -Append
    "For more information, see: https://learn.microsoft.com/en-us/purview/ediscovery-identify-a-hold-on-an-exchange-online-mailbox" | Out-File -FilePath $outputFile -Append
    "" | Out-File -FilePath $outputFile -Append

    $retentionHoldEnabled = Get-Mailbox $mailboxIdentity | Select-Object -ExpandProperty RetentionHoldEnabled
    "Retention Hold Enabled: $retentionHoldEnabled" | Out-File -FilePath $outputFile -Append
    "" | Out-File -FilePath $outputFile -Append
}

Get-RetentionHoldStatus -mailboxIdentity $mailboxIdentity -outputFile $outputFile

#endregion Retention Hold

#region Delay Hold

function Get-DelayHoldStatus {
    param (
        [string]$mailboxIdentity,
        [string]$outputFile
    )
    
    "===================== Delay Hold Status =====================" | Out-File -FilePath $outputFile -Append
    "A Delay Hold means that the actual removal of a hold is delayed for 30 days to prevent data from being permanently deleted (purged) from the mailbox." | Out-File -FilePath $outputFile -Append
    "This ensures that data is recoverable for a period after the hold is removed." | Out-File -FilePath $outputFile -Append
    "For more information, see: https://learn.microsoft.com/en-us/purview/ediscovery-identify-a-hold-on-an-exchange-online-mailbox" | Out-File -FilePath $outputFile -Append
    "" | Out-File -FilePath $outputFile -Append

    "Delay Hold Status for Mailbox: $mailboxIdentity" | Out-File -FilePath $outputFile -Append
    Get-Mailbox $mailboxIdentity | FL DelayHoldApplied, DelayReleaseHoldApplied | Out-File -FilePath $outputFile -Append
    "" | Out-File -FilePath $outputFile -Append
}

Get-DelayHoldStatus -mailboxIdentity $mailboxIdentity -outputFile $outputFile

#endregion Delay Hold

#region Optional: Retention Label Policies

function Get-RetentionLabelDetails {
    param (
        [string]$mailboxIdentity,
        [string]$outputFile
    )
    
    "===================== Retention Label Policies =====================" | Out-File -FilePath $outputFile -Append
    "Retention Labels allow you to classify and apply retention settings to individual items or folders." | Out-File -FilePath $outputFile -Append
    "These labels can be applied manually or automatically based on conditions." | Out-File -FilePath $outputFile -Append
    "" | Out-File -FilePath $outputFile -Append

    "All Retention Labels in Purview" | Out-File -FilePath $outputFile -Append
    Get-ComplianceTag | Format-Table -Auto Name, Priority, RetentionAction, RetentionDuration, Workload | Out-File -FilePath $outputFile -Append

    "Details for Retention Label: Capstone Test" | Out-File -FilePath $outputFile -Append
    Get-ComplianceTag -Identity "Capstone Test" | Out-File -FilePath $outputFile -Append

    "Retention Label Status for Mailbox: $mailboxIdentity" | Out-File -FilePath $outputFile -Append
    Get-Mailbox $mailboxIdentity | FL ComplianceTagHoldApplied | Out-File -FilePath $outputFile -Append
    "" | Out-File -FilePath $outputFile -Append
}

# Optional switch to include Retention Label Policies details
$IncludeRetentionLabelDetails = $false  # Set to $true to include Retention Label Policies details

if ($IncludeRetentionLabelDetails) {
    Get-RetentionLabelDetails -mailboxIdentity $mailboxIdentity -outputFile $outputFile
}

#endregion Optional: Retention Label Policies

#region Optional: MRM Retention Policies

function Get-MRMRetentionDetails {
    param (
        [string]$mailboxIdentity,
        [string]$outputFile
    )
    
    "===================== MRM Retention Policies =====================" | Out-File -FilePath $outputFile -Append
    "MRM (Messaging Records Management) Retention Policies are used to manage the lifecycle of email items in Exchange Online." | Out-File -FilePath $outputFile -Append
    "These policies define how long items are retained and what action is taken when the retention period expires." | Out-File -FilePath $outputFile -Append
    "" | Out-File -FilePath $outputFile -Append

    "MRM Retention Policy Details" | Out-File -FilePath $outputFile -Append
    $retentionPolicy = Get-RetentionPolicy -Identity "Default MRM Policy" | Format-List | Out-File -FilePath $outputFile -Append

    "MRM Retention Tag Details: 1 Month Delete" | Out-File -FilePath $outputFile -Append
    Get-RetentionPolicyTag "1 Month Delete" | Out-File -FilePath $outputFile -Append

    "MRM Retention Policy Status for Mailbox: $mailboxIdentity" | Out-File -FilePath $outputFile -Append
    if ($retentionPolicy) {
        $retentionPolicyTags = Get-RetentionPolicyTag | Where-Object { $_.RetentionPolicy -eq $retentionPolicy }
        "Retention Policy Tags for Mailbox: $mailboxIdentity" | Out-File -FilePath $outputFile -Append
        $retentionPolicyTags | ForEach-Object {
            "  - $($_.Name): Type=$($_.Type), AgeLimitForRetention=$($_.AgeLimitForRetention), RetentionAction=$($_.RetentionAction)" | Out-File -FilePath $outputFile -Append
        }
    } else {
        "No retention policy applied to this mailbox." | Out-File -FilePath $outputFile -Append
    }
    "" | Out-File -FilePath $outputFile -Append
}

# Optional switch to include MRM Retention Policies details
$IncludeMRMRetentionDetails = $false  # Set to $true to include MRM Retention Policies details

if ($IncludeMRMRetentionDetails) {
    Get-MRMRetentionDetails -mailboxIdentity $mailboxIdentity -outputFile $outputFile
}

#endregion Optional: MRM Retention Policies

#region Optional: Capstone Policy Details

function Get-CapstonePolicyDetails {
    param (
        [string]$policyName,
        [string]$outputFile
    )
    
    "===================== Capstone Policy Details =====================" | Out-File -FilePath $outputFile -Append
    "Retention Policy Details for: $policyName" | Out-File -FilePath $outputFile -Append
    Get-RetentionCompliancePolicy -Identity $policyName -DistributionDetail | Format-List | Out-File -FilePath $outputFile -Append
    "" | Out-File -FilePath $outputFile -Append
}

# Optional switch to include Capstone policy details
$IncludePolicyDetails = $false  # Set to $true to include Capstone policy details

if ($IncludePolicyDetails) {
    Get-CapstonePolicyDetails -policyName "Capstone" -outputFile $outputFile
}

#endregion Optional: Capstone Policy Details

Write-Host "Retention report generated at: $outputFile"