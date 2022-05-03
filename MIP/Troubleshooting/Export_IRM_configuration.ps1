<#

    -Created by: Wesley Blackwell
    -Date last updated: 5/2/2022

    -Overview:
        This script is designed to display what the active IRM settings are. This can be useful in troubleshooting MIP.
    -Overview doc, Get-IRMConfiguration: https://docs.microsoft.com/en-us/powershell/module/exchange/get-irmconfiguration?view=exchange-ps

    -Permissions Needed:
        -Global Admin (confirmed): Preferred since this user can see everything. 
        -Compliance Management // Hygience Management // Organization Management // View-Only Organization Management: Get-IRMConfiguration

    -Modules Needed:
        -ExchangeOnlineManagement

    -Notes:
        -Cmdlets will be downloaded when the session is active.
        -Security permissions need to be active first. If user is not an admin, the command will just fail to execute without giving a permission error.
#>

Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName user@yourdomain.com

Get-IRMConfiguration | fl