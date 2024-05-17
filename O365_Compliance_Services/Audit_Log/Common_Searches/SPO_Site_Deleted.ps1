#TODO fields needed to run script, supplied as parameters
    #-Site URL
    #-Date time range, default to todays date if not supplied as a parameter

#TODO activity to look for
    #-"Deleted site" - record type is "SharePointFileOperation"

#TODO actions that script should perform
    #-take parameters
    #-search audit log
    #-export result to csv
param(
    [Parameter(Mandatory=$true)]
    [string]$SiteUrl,

    [Parameter(Mandatory=$false)]
    [datetime]$StartDate,

    [Parameter(Mandatory=$false)]
    [datetime]$EndDate,

    [Parameter(Mandatory=$false)]
    [int]$DaysBack
)


# Install the ExchangePowerShell module if it's not already installed
# Check if the ExchangePowerShell module is available
$module = Get-Module -ListAvailable -Name ExchangePowerShell

# If the module is not found, install it
if (-not $module) {
    Write-Host "ExchangePowerShell module is not installed. Installing now..."
    # Installing the ExchangePowerShell module
    Install-Module -Name ExchangePowerShell -Force
    Write-Host "ExchangePowerShell module installed successfully."
} else {
    Write-Host "ExchangePowerShell module is already installed."
}

# Import the module
Import-Module ExchangeOnlineManagement

# Connect to the Compliance Center
Connect-ExchangeOnline

# Determine the date range for the audit log search
if ($DaysBack) {
    $endDate = Get-Date
    $startDate = $endDate.AddDays(-$DaysBack)
} elseif ($StartDate -and $EndDate) {
    $startDate = $StartDate
    $endDate = $EndDate
} else {
    Write-Error "Either specify both StartDate and EndDate, or specify DaysBack."
    exit
}

# Search the audit log for SharePoint site deletion events
$searchResults = Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -RecordType SharePoint -Operations 'SiteDeleted' -ObjectIds $SiteUrl

# Export the results to a CSV file
$csvPath = "AuditLogResults.csv"
$searchResults | Export-Csv -Path $csvPath -NoTypeInformation

# Disconnect the session
Disconnect-ExchangeOnline