<#
.SYNOPSIS
This script updates specified properties in the property bag of SharePoint Online sites based on a CSV template.

.DESCRIPTION
Using the PnP.PowerShell module, this script connects to each SharePoint Online site listed in a CSV file and sets or updates the specified property bag keys and values for each site.

.INSTRUCTIONS
1. Ensure you have the PnP.PowerShell module installed.
2. Create a CSV file with the following structure:
    SiteURL,key,value
    https://yourtenant.sharepoint.com/sites/Site1,Key1,Value1
    https://yourtenant.sharepoint.com/sites/Site2,Key2,Value2
3. Update the $csvPath variable in the script to point to the location of your CSV file.
4. Run the script in PowerShell.

.PERMISSIONS
- SharePoint Admin or Site Collection Admin

.MODULES NEEDED
- PnP.PowerShell

.EXAMPLE
.\Update-SitePropertyBag.ps1

This will read site URLs, keys, and values from the CSV file and update the specified property bag keys for each site.

.NOTES
File Name      : Update-SitePropertyBag.ps1
Author         : Wes Blackwell
Prerequisite   : PnP.PowerShell Module
#>

# Check if PnP.PowerShell module is installed and imported
if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
    Install-Module -Name PnP.PowerShell -Force
}
Import-Module PnP.PowerShell
# Load the CSV file
$csvPath = "C:\path\to\your\csvfile.csv"
$sites = Import-Csv -Path $csvPath

foreach ($site in $sites) {
    $siteUrl = $site.SiteURL
    $key = $site.key
    $value = $site.value

    try {
        # Connect to the SharePoint Online site
        Connect-PnPOnline -Url $siteUrl -UseWebLogin

        # Set the property bag value
        Set-PnPAdaptiveScopeProperty -Key $key -Value $value

        # Get the site's property bag
        $propertyBag = Get-PnPPropertyBag

        # Output the property bag
        $propertyBag

        Write-Host "Property bag for site $siteUrl has been updated." -ForegroundColor Green
    } catch {
        Write-Error "An error occurred while processing site ${siteUrl}: $_"
    }
}