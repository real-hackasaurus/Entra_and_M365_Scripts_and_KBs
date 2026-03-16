Import-Module ExchangeOnlineManagement

Connect-IPPSSession -UserPrincipalName "admin@M365x34890247.onmicrosoft.com"

Set-RetentionCompliancePolicy -Identity "DEI Policy" -AddSharePointLocation "https://m365x34890247.sharepoint.com/sites/Design" -AddModernGroupLocation "Design@M365x34890247.onmicrosoft.com"

