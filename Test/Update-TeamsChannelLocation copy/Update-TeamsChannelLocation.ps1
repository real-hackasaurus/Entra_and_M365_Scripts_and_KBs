<#
.SYNOPSIS
Updates a retention compliance policy to add Teams channel locations.

.DESCRIPTION
This script imports the ExchangeOnlineManagement module, connects to the Security & Compliance Center, and updates a specified retention compliance policy by adding Teams channel locations.

.INSTRUCTIONS
1. Ensure you have the ExchangeOnlineManagement module installed.
2. Update the UserPrincipalName with your admin UPN.
3. Update the -Identity parameter with your retention policy name.
4. Update the -AddTeamsChannelLocation value as needed.
5. Run the script in PowerShell.

.PERMISSIONS
- Global Administrator or Compliance Administrator

.MODULES NEEDED
- ExchangeOnlineManagement

.EXAMPLE
.\Update-TeamsChannelLocation.ps1

This will connect to the Security & Compliance Center and update the specified retention policy with Teams channel locations.

.NOTES
File Name      : Update-TeamsChannelLocation.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

Import-Module ExchangeOnlineManagement

Connect-IPPSSession -UserPrincipalName "admin@M365x34890247.onmicrosoft.com"

Set-RetentionCompliancePolicy -Identity "DEI Teams Policy" -AddTeamsChannelLocation "Contoso marketing"
