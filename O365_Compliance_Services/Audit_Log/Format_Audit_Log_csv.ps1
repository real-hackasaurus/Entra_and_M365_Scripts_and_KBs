<#

    -Created by: Wesley Blackwell
    -Date last updated: 9/24/2023

    -Overview:
        This sciprt can help export and filter audit logs for SPO sites. 

    -Permissions Needed:
        -Global Admin
        -Compliance Admin

    -Modules Needed:
        -ExchangeOnlineManagement

    -Notes:
        -Cmdlets will be downloaded when the session is active. 
        -Security permissions need to be active first. If user is not an admin, the command will just fail to execute without giving a permission error.
#>
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName user@yourdomain.com

"C:\TEMP\Audit_Log\exportedAuditLog.csv" | ConvertFrom-Json | Select CreationTime, UserId, Operation, ObjectID, SiteUrl, SourceFileName, ClientIP | Export-csv "C:\TEMP\Audit_Log\filteredAuditLog.csv" -NoTypeInformation -Force