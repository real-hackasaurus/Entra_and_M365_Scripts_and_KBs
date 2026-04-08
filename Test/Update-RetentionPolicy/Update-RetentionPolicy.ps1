<#
.SYNOPSIS
Updates a retention compliance policy to add SharePoint and Modern Group locations.

.DESCRIPTION
This script imports the ExchangeOnlineManagement module, connects to the Security & Compliance Center, and updates a specified retention compliance policy by adding SharePoint and Modern Group locations.

.INSTRUCTIONS
1. Ensure you have the ExchangeOnlineManagement module installed.
2. Update the UserPrincipalName with your admin UPN.
3. Update the -Identity parameter with your retention policy name.
4. Update the -AddSharePointLocation and -AddModernGroupLocation values as needed.
5. Run the script in PowerShell.

.PERMISSIONS
- Global Administrator or Compliance Administrator

.MODULES NEEDED
- ExchangeOnlineManagement

.EXAMPLE
.\Update-RetentionPolicy.ps1

This will connect to the Security & Compliance Center and update the specified retention policy.

.NOTES
File Name      : Update-RetentionPolicy.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

Import-Module ExchangeOnlineManagement

Connect-IPPSSession -UserPrincipalName "admin@M365x34890247.onmicrosoft.com"

Set-RetentionCompliancePolicy -Identity "DEI Policy" -AddSharePointLocation "https://m365x34890247.sharepoint.com/sites/Design" -AddModernGroupLocation "Design@M365x34890247.onmicrosoft.com"

