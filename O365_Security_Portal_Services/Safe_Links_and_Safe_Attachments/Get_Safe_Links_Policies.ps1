<#

    -Created by: Wesley Blackwell
    -Date last updated: 5/3/2022

    -Overview:
        This script is designed to export all O365 Threat Protection rules (old atp) from the portal and put them in a csv.
    -Overview doc, Get-SafeLinksPolicy: https://docs.microsoft.com/en-us/powershell/module/exchange/get-safelinkspolicy?view=exchange-ps
    -Overview doc, Get-SafeLinksRule: https://docs.microsoft.com/en-us/powershell/module/exchange/get-safelinksrule?view=exchange-ps
    

    -Permissions Needed:
        -Global Admin (confirmed): Preferred since this user can see everything. 
        -Security admin: All cmdlets

    -Modules Needed:
        -ExchangeOnlineManagement

    -Notes:
        -Cmdlets will be downloaded when the session is active.
        -Security permissions need to be active first. If user is not an admin, the command will just fail to execute without giving a permission error.
        -Save and run in local runspace so files save where you want them to.
#>

Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName youruser@domain.com

#This cmdlet will pull all policies available for Safe Links.
Get-SafeLinksPolicy | Export-Csv -Path .\SafeLinksPolicy.csv -NoTypeInformation

#This cmdlet will pull all hand-built policies and more details about how it functions.
Get-SafeLinksRule | Export-Csv -Path .\SafeLinksRule.csv -NoTypeInformation