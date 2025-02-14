<#
    -Created by: Wesley Blackwell
    -Date last updated: 9/24/2023

    -Overview:
        This script can help export and filter audit logs for SPO sites. 

    -Permissions Needed:
        -Global Admin
        -Compliance Admin

    -Modules Needed:
        -ExchangeOnlineManagement

    -Notes:
        -Cmdlets will be downloaded when the session is active. 
        -Security permissions need to be active first. If user is not an admin, the command will just fail to execute without giving a permission error.
#>

# Import the Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Define variables
$upn = "user@yourdomain.com"
$inputFilePath = "C:\TEMP\Audit_Log\exportedAuditLog.csv"
$outputFilePath = "C:\TEMP\Audit_Log\filteredAuditLog.csv"

# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName $upn

# Convert and filter the audit log
Get-Content $inputFilePath | ConvertFrom-Json | Select CreationTime, UserId, Operation, ObjectID, SiteUrl, SourceFileName, ClientIP | Export-Csv $outputFilePath -NoTypeInformation -Force