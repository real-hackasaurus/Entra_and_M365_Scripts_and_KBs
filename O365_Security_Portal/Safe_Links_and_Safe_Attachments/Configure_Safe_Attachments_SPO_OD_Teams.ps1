<#

    -Created by: Wesley Blackwell
    -Date last updated: 5/3/2022

    -Overview:
        This script is designed to protect SPO, OD, and Teams with Safe Attachments and then verify the settings have taken place. Use files from the Demo section to test malicious file upload.
    -Overview doc, most instrucitons built from here: https://docs.microsoft.com/en-us/microsoft-365/security/office-365-security/turn-on-mdo-for-spo-odb-and-teams?view=o365-worldwide

    -Permissions Needed:
        -Global Admin (confirmed): Preferred since this user can see everything. 
        -SharePoint admin privileges

    -Modules Needed:
        -ExchangeOnlineManagement

    -Notes:
        -Cmdlets will be downloaded when the session is active.
        -Security permissions need to be active first. If user is not an admin, the command will just fail to execute without giving a permission error.
#>

Import-Module ExchangeOnlineManagement
Update-Module -Name Microsoft.Online.SharePoint.PowerShell
#UPDATE: URL BELOW FOR ORG
Connect-ExchangeOnline -UserPrincipalName admin@contoso.onmicrosoft.com

#Step 1: Turn on Safe Attachments for SharePoint, OneDrive, and Microsoft Teams
Set-AtpPolicyForO365 -EnableATPForSPOTeamsODB $true

#Step 2: Use SharePoint Online PowerShell to prevent users from downloading malicious files
#NOTE: You will need to sign in again using just the connect line below. This command is formatted incase MFA is required. 
#UPDATE: URL BELOW FOR ORG
Connect-SPOService -Url https://contoso-admin.sharepoint.com
Set-SPOTenant -DisallowInfectedFileDownload $true

#Step 3: Create an alert policy for detected files
#UPDATE: URL BELOW FOR ORG
New-ActivityAlert -Name "Malicious Files in Libraries" -Description "Notifies admins when malicious files are detected in SharePoint Online, OneDrive, or Microsoft Teams" -Category ThreatManagement -Operation FileMalwareDetected -NotifyUser "admin1@contoso.com","admin2@contoso.com"



#Verify Settings are turned on
#Verify Step 1: 
Get-AtpPolicyForO365 | Format-List EnableATPForSPOTeamsODB

#Verify Step 2:
Get-SPOTenant | Format-List DisallowInfectedFileDownload

#Verify Step 3:
Get-ActivityAlert -Identity "<AlertPolicyName>"