<#

    -Created by: Wesley Blackwell
    -Date last updated: 9/24/2023

    -Overview:
        This script contains several commands for DLP policy and rule creation.

    -Permissions Needed:
        -Global Admin
        -Compliance Admin

    -Modules Needed:
        -ExchangeOnlineManagement

    -Notes:
        -Cmdlets will be downloaded when the session is active. 
        -Security permissions need to be active first. If user is not an admin, the command will just fail to execute without giving a permission error.
        -Can take up to 15 minutes for policy to sync
        -Sensitive labels need the id GUID in place of the name, this can also cause issues in the portal where the name shows blank
        -IncidentReport send alert to to admins does not seem to work. GenerateAlert and GenerateIncidentReport does not activate it.
        -Value "-1"  is "Any" for sensitive information type, within the .txt file for rule
#>

Import-Module ExchangeOnlineManagement

Connect-IPPSSession -UserPrincipalName "user@contoso.com"

#Get a sensitive information type by name
Get-DlpSensitiveInformationType -Identity "My Policy Name" | Format-List

#Get a list of all DLP Policies
Get-DlpCompliancePolicy

#Get a specific policy by name
Get-DlpCompliancePolicy -Identity "My Policy Name" | Format-List

#Get a specific rule by name
Get-DlpComplianceRule -Identity "My Rule Name" | Format-List
#Same as above but output to file
Get-DlpComplianceRule -Identity "My Rule Name"| Format-List | Out-File -FilePath "C:\TEMP\DLP_Policy\output.txt"

#Create new DLP policy
New-DlpCompliancePolicy -Name "My Policy Name" -ExchangeLocation All -Mode TestWithoutNotifications

#Read the content of a .txt file to create a new rule
$rule = Get-Content -Path "C:\TEMP\DLP_Policy\rule.txt" -ReadCount 0
#Read the content of a .txt file to create a new custom email body
$email = Get-Content -Path "C:\TEMP\DLP_Policy\email.txt" -ReadCount 0

#Create new DLP rule
New-DLPComplianceRule -Name "My Rule Name" -Policy "My Policy Name" `
-AdvancedRule $rule -NotifyUser LastModifier, user@contoso.com, user2@contoso.com `
-NotifyUserType Email -NotifyEmailCustomText $email -Priority 0

#Set new values for a DLP rule
Set-DLPComplianceRule -Identity "My Rule Name" -NotifyUser LastModifier, user@contoso.com, user2@contoso.com `
-NotifyUserType Email -NotifyEmailCustomText $email -GenerateAlert SiteAdmin -Priority 0

Set-DLPComplianceRule -Identity "My Rule Name" -GenerateIncidentReport "user@contoso.com"