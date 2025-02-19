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
