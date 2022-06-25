<#

    -Created by: Wesley Blackwell
    -Date last updated: 6/25/2022

    -Overview:
        This script is designed to display the detials of the current AIP service
    -Overview doc, Get-AipServiceConfiguration: https://docs.microsoft.com/en-us/powershell/module/aipservice/get-aipserviceconfiguration?view=azureipps

    -Permissions Needed:
        -Global Admin (confirmed)

    -Modules Needed:
        -AIPService

    -Notes:
#>

#AIPService doc manual
#https://docs.microsoft.com/en-us/powershell/module/aipservice/?view=azureipps

Import-Module AIPService
Connect-AipService

Get-AipServiceConfiguration