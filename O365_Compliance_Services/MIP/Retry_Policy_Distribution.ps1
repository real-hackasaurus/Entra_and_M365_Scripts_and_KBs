<#

    -Created by: Wesley Blackwell
    -Date last updated: 5/2/2022

    -Overview:
        This script is designed to retry policy distribution if the distribution status may be hung up (i.e. pending).
    -Overview doc, Set-LabelPolicy: https://docs.microsoft.com/en-us/powershell/module/exchange/set-labelpolicy?view=exchange-ps

    -Permissions Needed:
        -Global  (confirmed): Preferred since this user can see everything. 
        -Compliance Management // Hygience Management // Organization Management // View-Only Organization Management: Get-IRMConfiguration

    -Modules Needed:
        -ExchangeOnlineManagement

    -Notes:
        -!!!ONLY RUN ONE POLICY AT A TIME. DO NOT RUN AGAIN TILL THE FIRST RETRY IS FINISHED. CAN CAUSE HANG UPS.!!!
#>

Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName yourupn@domain.com

Set-LabelPolicy -RetryDistribution -Identity "Demo - Policy"