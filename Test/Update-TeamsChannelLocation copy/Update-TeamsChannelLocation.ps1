Import-Module ExchangeOnlineManagement

Connect-IPPSSession -UserPrincipalName "admin@M365x34890247.onmicrosoft.com"

Set-RetentionCompliancePolicy -Identity "DEI Teams Policy" -AddTeamsChannelLocation "Contoso marketing"
