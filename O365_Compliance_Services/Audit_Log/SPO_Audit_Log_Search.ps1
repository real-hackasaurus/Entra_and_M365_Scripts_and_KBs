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
#Filter Audit log to Find specific operations
###INSTRUCITONS###
#
# Can only pull data that is right under 6 months old.
# Modify the $StartDate variable to the time range in days the audit log should be pulled for
$StartDate = (Get-Date).AddDays(-60)
$EndDate = Get-Date

###INSTRUCITONS###
#
# Modify the $SiteURLs array to hold each site that should be pulled. 
# Remember to add a comma after each site in quotes (ex "mysite", ) except for the last site inthe array
$SiteURLs = @(
    "https://nih.sharepoint.com/sites/HRSA-OO-OIT-Managers/*",
    "https://nih.sharepoint.com/sites/HRSA-OO-OIT-BO/*",
    "https://nih.sharepoint.com/sites/hrsa-oo-ohr/*",
    "https://nih.sharepoint.com/sites/hrsa-oo-oam/*",
    "https://nih.sharepoint.com/sites/hrsa-oo-oamp/*",
    "https://nih.sharepoint.com/sites/HRSA-OO-ExecSec/*"
    )

###INSTRUCITONS###
#
# Rename file location, TIP: update the file to be similar to MysiteAuditLog.CSV
# !!IMPORTANT!! this array needs to have the same number of indexs as $SiteURLs to work
$CSVFile = @(
    "C:\TEMP\auditlogs\HRSA-OO-OIT-Managers_AuditLog.csv",
    "C:\TEMP\auditlogs\HRSA-OO-OIT-BO_AuditLog.csv",
    "C:\TEMP\auditlogs\hrsa-oo-ohr_AuditLog.csv",
    "C:\TEMP\auditlogs\hrsa-oo-oam_AuditLog.csv",
    "C:\TEMP\auditlogs\hrsa-oo-oamp_AuditLog.csv",
    "C:\TEMP\auditlogs\HRSA-OO-ExecSec_AuditLog.csv"
    )
  
# This section loops throught the siteurls, uses the index as the position, and runs the report for each site and file
for ($i=0; $i -lt $SiteURLs.Length; $i++) {
    try {
            #Below are most useful file related events for a audit log
            $FileAccessOperations = @('FileModified','FileCopied', 'FileMoved','FileAccessed', 'FileRenamed','FileDeleted','FileDownloaded','FileRecycled','FileUploaded','FolderDeleted','FolderModified','FolderRenamed','FolderMoved','FolderCopied')

            #Now we run the search and hold to $FileAccessLog
            #5000 is the result size limit
            $FileAccessLog = Search-UnifiedAuditLog -StartDate $StartDate -EndDate $EndDate -Operations $FileAccessOperations -ResultSize 5000 -ObjectIds $SiteURLs[$i]

            #FileAccessLog comes through as a CSV containing JSON. This will parse the main JSON section (AuditData) and then select only the properties we want and in the order we want
            $FileAccessLog.AuditData | ConvertFrom-Json | Select CreationTime, UserId, Operation, ObjectID, SiteUrl, SourceFileName, ClientIP | Export-csv $CSVFile[$i] -NoTypeInformation -Force
        }
        catch {
            Write-Output "Issue encountered for site: $SiteURLs[$i]" 
        }
}