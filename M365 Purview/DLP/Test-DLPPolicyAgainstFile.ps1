<#
.SYNOPSIS
Tests DLP policies against a specified SharePoint Online or OneDrive file.

.DESCRIPTION
This script uses the ExchangeOnlineManagement module to retrieve the SharePoint site ID via Get-Mailbox,
and then tests DLP policies against a specified file using the Test-DlpPolicies cmdlet. A report is sent
to the specified email address.

.INSTRUCTIONS
1. Ensure you have the PnP.PowerShell and ExchangeOnlineManagement modules installed.
2. Run the script with the required parameters: ReportAddress, SiteName, and FileUrl.
3. Review the report sent to the specified email address.

.PERMISSIONS
- Global Administrator or Compliance Administrator

.MODULES NEEDED
- PnP.PowerShell
- ExchangeOnlineManagement

.PARAMETER ReportAddress
The email address to receive the DLP policy test report.

.PARAMETER SiteName
The SharePoint site group mailbox identity (e.g., "Marketing@contoso.onmicrosoft.com").

.PARAMETER FileUrl
The full URL to the SharePoint Online or OneDrive file to test against DLP policies.

.EXAMPLE
.\Test-DLPPolicyAgainstFile.ps1 -ReportAddress "admin@contoso.com" -SiteName "Marketing@contoso.onmicrosoft.com" -FileUrl "https://contoso.sharepoint.com/sites/Marketing/Shared%20Documents/test.docx"

.NOTES
File Name      : Test-DLPPolicyAgainstFile.ps1
Author         : Wes Blackwell
Prerequisite   : PnP.PowerShell Module, ExchangeOnlineManagement Module
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ReportAddress,

    [Parameter(Mandatory = $true)]
    [string]$SiteName,

    [Parameter(Mandatory = $true)]
    [string]$FileUrl
)

# Check if PnP.PowerShell module is installed and imported
if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
    Install-Module -Name PnP.PowerShell -Force -Scope CurrentUser
}
Import-Module PnP.PowerShell

# Check if ExchangeOnlineManagement module is installed and imported
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Force -Scope CurrentUser
}
Import-Module ExchangeOnlineManagement

try {
    # Retrieve Site ID via Group Mailbox
    $r = Get-Mailbox -Identity $SiteName -GroupMailbox
    $e = $r.EmailAddresses | Where-Object { $_ -like '*SPO*' }
    $siteId = $e.Substring(8, 36)

    # Test DLP Policies on the specified file
    Test-DlpPolicies -SiteId $siteId -FileUrl $FileUrl -Workload SPO -SendReportTo $ReportAddress

    Write-Output "DLP policy test completed. Report sent to $ReportAddress."
} catch {
    Write-Error "An error occurred while testing DLP policies: $_"
} finally {
    # Disconnect from Exchange Online
    Disconnect-ExchangeOnline -Confirm:$false
}
