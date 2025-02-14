<#

    -Created by: Wesley Blackwell
    -Date last updated: 5/3/2022

    -Overview:
        This script is designed to export all Activity and Alert policies in the Security Portal.
    -Overview doc, Get-ActivityAlert: https://docs.microsoft.com/en-us/powershell/module/exchange/get-activityalert?view=exchange-ps
    -Overview doc, Get-ProtectionAlert: https://docs.microsoft.com/en-us/powershell/module/exchange/get-protectionalert?view=exchange-ps

    -Permissions Needed:
        -Global Admin (confirmed): Preferred since this user can see everything. 

    -Modules Needed:
        -ExchangeOnlineManagement

    -Notes:
        -Cmdlets will be downloaded when the session is active.
        -Security permissions need to be active first. If user is not an admin, the command will just fail to execute without giving a permission error.
#>

Import-Module ExchangeOnlineManagement
#UPDATE: URL BELOW FOR ORG
Connect-IPPSSession -UserPrincipalName admin@contoso.onmicrosoft.com

#This cmdlet will pull all activity alerts found under the Security portal > Policies and rules > Activity Alerts.
Get-ActivityAlert | Export-Csv -Path .\ActivityAlert.csv -NoTypeInformation

#This cmdlet will pull all activity alerts found under the Security portal > Policies and rules > Alert Policy.
Get-ProtectionAlert | Export-Csv -Path .\ProtectionAlert.csv -NoTypeInformation