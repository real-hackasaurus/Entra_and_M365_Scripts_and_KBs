<#
.SYNOPSIS
Tests DLP policies against a specified SharePoint Online or OneDrive file.

.DESCRIPTION
This script uses the PnP.PowerShell module to retrieve the SharePoint site ID and then tests DLP policies against a specified file using the Test-DlpPolicies cmdlet.

.INSTRUCTIONS
1. Ensure you have the PnP.PowerShell module installed.
2. Update the $reportAddress variable with the email address to receive the report.
3. Update the $siteName variable with the SharePoint site name.
4. Update the $filePath variable with the full URL to the file to test.
5. Run the script in PowerShell.

.PERMISSIONS
- Global Administrator or Compliance Administrator

.MODULES NEEDED
- PnP.PowerShell

.EXAMPLE
.\Test dlp policy against SPO or OD file.ps1

This will test DLP policies against the specified file and send a report to the configured email address.

.NOTES
File Name      : Test dlp policy against SPO or OD file.ps1
Author         : Wes Blackwell
Prerequisite   : PnP.PowerShell Module
#>

# Variables
$reportAddress = "email@contoso.com"
$siteName = "SITENAME@TENANT.onmicrosoft.com"
$filePath = "https://Contoso.sharepoint.com/sites/SOMESITENAME/Shared%20Documents/TESTFILE.pptx"

# Check if PnP.PowerShell module is installed and imported
if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
    Install-Module -Name PnP.PowerShell -Force
}
Import-Module PnP.PowerShell

# Retrieve Site ID
$r = Get-Mailbox -Identity $siteName -GroupMailbox
$e = $r.EmailAddresses | Where-Object {$_ -like '*SPO*'}
$siteId = $e.Substring(8, 36)

# Test DLP Policies on the specified file
Test-DlpPolicies -SiteId $siteId -FileUrl $filePath -Workload SPO -SendReportTo $reportAddress
