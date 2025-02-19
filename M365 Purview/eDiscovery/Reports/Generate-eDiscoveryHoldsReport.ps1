<#
.SYNOPSIS
Generates a report of eDiscovery holds in the Security & Compliance Center.

.DESCRIPTION
This script connects to the Security & Compliance Center, retrieves information about eDiscovery cases and holds, and generates a report in CSV format.

.INSTRUCTIONS
1. Ensure you have the ExchangeOnlineManagement module installed.
2. Connect to your Office 365 using the Connect-IPPSSession cmdlet.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
You need to have sufficient permissions to access eDiscovery holds in the Security & Compliance Center.

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETER UserPrincipalName
The User Principal Name of the admin account to connect to Exchange Online.

.PARAMETER OutputPath
The folder path where the report CSV files will be saved.

.EXAMPLE
.\Generate-eDiscoveryHoldsReport.ps1 -UserPrincipalName "user@contoso.com" -OutputPath "C:\Reports"

This will generate a report of eDiscovery holds and save it to the specified folder.

.NOTES
File Name      : Generate-eDiscoveryHoldsReport.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$UserPrincipalName = $env:USER_PRINCIPAL_NAME,

    [Parameter(Mandatory=$true)]
    [string]$OutputPath = $env:OUTPUT_PATH
)

# Ensure parameters are not empty
try {
    if (-not $UserPrincipalName) {
        Write-Error "UserPrincipalName parameter is empty or not set!"
        exit
    }

    if (-not $OutputPath) {
        Write-Error "OutputPath parameter is empty or not set!"
        exit
    }
} catch {
    Write-Error "Error checking parameters: $_"
    exit
}

# Check if the ExchangeOnlineManagement module is installed and imported
try {
    if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
        Install-Module -Name ExchangeOnlineManagement -Force
    }
    Import-Module ExchangeOnlineManagement
} catch {
    Write-Error "Failed to install or import ExchangeOnlineManagement module: $_"
    exit
}

# Connect to Exchange Online
try {
    Connect-IPPSSession -UserPrincipalName $UserPrincipalName
} catch {
    Write-Error "Failed to connect to Exchange Online: $_"
    exit
}

# Script begin
" "
write-host "***********************************************"
write-host "Security & Compliance Center   " -foregroundColor yellow -backgroundcolor darkgreen
write-host "eDiscovery cases - Holds report         " -foregroundColor yellow -backgroundcolor darkgreen
write-host "***********************************************"
" "

# Prompt users to specify a path to store the output files
$time = get-date -Format dd-MM-yyyy_hh.mm
$outputpath = $OutputPath + '\' + 'CaseHoldsReport' + ' ' + $time + '.csv'
$noholdsfilepath = $OutputPath + '\' + 'CaseswithNoHolds' + $time + '.csv'

# Add case details to the csv file
function add-tocasereport {
    Param([string]$casename,
        [String]$casetype,
        [String]$casestatus,
        [datetime]$casecreatedtime,
        [string]$casemembers,
        [datetime]$caseClosedDateTime,
        [string]$caseclosedby,
        [string]$holdname,
        [String]$Holdenabled,
        [string]$holdcreatedby,
        [string]$holdlastmodifiedby,
        [string]$ExchangeLocation,
        [string]$sharePointlocation,
        [string]$ContentMatchQuery,
        [datetime]$holdcreatedtime,
        [datetime]$holdchangedtime,
        [string]$holdstatus,
        [string]$holderror
    )

    $addRow = New-Object PSObject
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Case name" -Value $casename
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Case type" -Value $casetype
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Case status" -Value $casestatus
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Case members" -Value $casemembers
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Case created time" -Value $casecreatedtime
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Case closed time" -Value $caseClosedDateTime
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Case closed by" -Value $caseclosedby
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Hold name" -Value $holdname
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Hold enabled" -Value $Holdenabled
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Hold created by" -Value $holdcreatedby
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Hold last changed by" -Value $holdlastmodifiedby
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Exchange locations" -Value  $ExchangeLocation
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "SharePoint locations" -Value $sharePointlocation
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Hold query" -Value $ContentMatchQuery
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Hold created time (UTC)" -Value $holdcreatedtime
    Add-Member -InputObject $addRow -MemberType NoteProperty -Name "Hold changed time (UTC)" -Value $holdchangedtime
    Add-Member -InputObject $addrow -MemberType NoteProperty -Name "Hold Status" -Value $holdstatus
    Add-Member -InputObject $addrow -MemberType NoteProperty -Name "Hold Error" -Value $holderror

    $allholdreport = $addRow | Select-Object "Case name", "Case type", "Case status", "Hold name", "Hold enabled", "Case members", "Case created time", "Case closed time", "Case closed by", "Exchange locations", "SharePoint locations", "Hold query", "Hold created by", "Hold created time (UTC)", "Hold last changed by", "Hold changed time (UTC)", "Hold Status", "Hold Error"
    $allholdreport | export-csv -path $outputPath -notypeinfo -append -Encoding ascii
}

# Get information on the cases and pass values to the case report function
" "
write-host "Gathering a list of eDiscovery (Standard) cases and holds..."
" "
$edc = Get-ComplianceCase -ErrorAction SilentlyContinue
foreach ($cc in $edc) {
    write-host "Working on case :" $cc.name
    if ($cc.status -eq 'Closed') {
        $cmembers = ((Get-ComplianceCaseMember -Case $cc.name).windowsLiveID) -join ';'
        add-tocasereport -casename $cc.name -casetype $cc.casetype -casestatus $cc.Status -caseclosedby $cc.closedby -caseClosedDateTime $cc.ClosedDateTime -casemembers $cmembers
    }
    else {
        $cmembers = ((Get-ComplianceCaseMember -Case $cc.name).windowsLiveID) -join ';'
        $policies = Get-CaseHoldPolicy -Case $cc.Name | % { Get-CaseHoldPolicy $_.Name -Case $_.CaseId -DistributionDetail }
        if ($policies -ne $NULL) {
            foreach ($policy in $policies) {
                $rule = Get-CaseHoldRule -Policy $policy.name
                add-tocasereport -casename $cc.name -casetype $cc.casetype -casemembers $cmembers -casestatus $cc.Status -casecreatedtime $cc.CreatedDateTime -holdname $policy.name -holdenabled $policy.enabled -holdcreatedby $policy.CreatedBy -holdlastmodifiedby $policy.LastModifiedBy -ExchangeLocation (($policy.exchangelocation.name) -join ';') -SharePointLocation (($policy.sharePointlocation.name) -join ';') -ContentMatchQuery $rule.ContentMatchQuery -holdcreatedtime $policy.WhenCreatedUTC -holdchangedtime $policy.WhenChangedUTC -holdstatus $policy.DistributionStatus -holderror $policy.DistributionResults
            }
        }
        else {
            Write-Host "No hold policies found in case:" $cc.name -foregroundColor 'Yellow'
            " "
            [string]$cc.name | out-file -filepath $noholdsfilepath -append
        }
    }
}

# Get information on the cases and pass values to the case report function
" "
write-host "Gathering a list of eDiscovery (Premium) cases and holds..."
" "
$edc = Get-ComplianceCase -CaseType Advanced -ErrorAction SilentlyContinue
foreach ($cc in $edc) {
    write-host "Working on case :" $cc.name
    if ($cc.status -eq 'Closed') {
        $cmembers = ((Get-ComplianceCaseMember -Case $cc.name).windowsLiveID) -join ';'
        add-tocasereport -casename $cc.name -casestatus $cc.Status -casetype $cc.casetype -caseclosedby $cc.closedby -caseClosedDateTime $cc.ClosedDateTime -casemembers $cmembers
    }
    else {
        $cmembers = ((Get-ComplianceCaseMember -Case $cc.name).windowsLiveID) -join ';'
        $policies = Get-CaseHoldPolicy -Case $cc.Name | % { Get-CaseHoldPolicy $_.Name -Case $_.CaseId -DistributionDetail }
        if ($policies -ne $NULL) {
            foreach ($policy in $policies) {
                $rule = Get-CaseHoldRule -Policy $policy.name
                add-tocasereport -casename $cc.name -casetype $cc.casetype -casemembers $cmembers -casestatus $cc.Status -casecreatedtime $cc.CreatedDateTime -holdname $policy.name -holdenabled $policy.enabled -holdcreatedby $policy.CreatedBy -holdlastmodifiedby $policy.LastModifiedBy -ExchangeLocation (($policy.exchangelocation.name) -join ';') -SharePointLocation (($policy.sharePointlocation.name) -join ';') -ContentMatchQuery $rule.ContentMatchQuery -holdcreatedtime $policy.WhenCreatedUTC -holdchangedtime $policy.WhenChangedUTC -holdstatus $policy.DistributionStatus -holderror $policy.DistributionResults

            }
        }
        else {
            write-host "No hold policies found in case:" $cc.name -foregroundColor 'Yellow'
            " "
            [string]$cc.name | out-file -filepath $noholdsfilepath -append
        }
    }
}

" "
Write-host "Script complete! Report files saved to this folder: '$OutputPath'"
" "
# Script end