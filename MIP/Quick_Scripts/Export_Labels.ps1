<#

    -Created by: Wesley Blackwell
    -Date last updated: 4/29/2022

    -Overview:
        This script is designed to just pull down all labels and label policies in an enviornment and export it to a txt file. 
    -Overview doc, Get-Label: https://docs.microsoft.com/en-us/powershell/module/exchange/get-label?view=exchange-ps
    -Overview doc, Get-LabelPolicy: https://docs.microsoft.com/en-us/powershell/module/exchange/get-labelpolicy?view=exchange-ps

    -Permissions Needed:
        -Security Admin or greater: Get-Label and Get-LabelPolicy

    -Modules Needed:
        -ExchangeOnlineManagement

    -Notes:
        -Cmdlets will be downloaded when the session is active.
        -Security permissions need to be active first. If user is not an admin, the command will just fail to execute without giving a permission error.
#>

Import-Module ExchangeOnlineManagement
Connect-IPPSSession -UserPrincipalName yourupn@domain.com

Start-Transcript
Get-Label | fl
Get-LabelPolicy | fl
Stop-Transcript