<#

    -Created by: Wesley Blackwell
    -Date last updated: 6/25/2022

    -Overview:
        This script is designed to export all details of the AIP service admin log. This includes admin commands that have been ran in PowerShell.
    -Overview doc, Get-AipServiceAdminLog: https://docs.microsoft.com/en-us/powershell/module/aipservice/get-aipserviceadminlog?view=azureipps

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

Get-AipServiceAdminLog -Path "C:\Temp\AdminLog.log"