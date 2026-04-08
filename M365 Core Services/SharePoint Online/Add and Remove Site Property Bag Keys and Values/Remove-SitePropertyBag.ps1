<#
.SYNOPSIS
This script removes specified properties from the property bag of SharePoint Online sites based on a CSV template.

.DESCRIPTION
Using the PnP.PowerShell module, this script connects to each SharePoint Online site listed in a CSV file and removes the specified property bag keys from each site.

.INSTRUCTIONS
1. Ensure you have the PnP.PowerShell module installed.
2. Create a CSV file with the following structure:
    SiteURL,key
    https://yourtenant.sharepoint.com/sites/Site1,Key1
    https://yourtenant.sharepoint.com/sites/Site2,Key2
3. Update the $csvPath variable in the script to point to the location of your CSV file.
4. Run the script in PowerShell.

.PERMISSIONS
- SharePoint Admin or Site Collection Admin

.MODULES NEEDED
- PnP.PowerShell

.EXAMPLE
.\Remove-SitePropertyBag.ps1

This will read site URLs and keys from the CSV file and remove the specified property bag keys from each site.

.NOTES
File Name      : Remove-SitePropertyBag.ps1
Author         : Wes Blackwell
Prerequisite   : PnP.PowerShell Module
#>

Import-Module PnP.PowerShell
# Load the CSV file
$csvPath = "C:\path\to\your\csvfile.csv"
$sites = Import-Csv -Path $csvPath

foreach ($site in $sites) {
    $siteUrl = $site.SiteURL
    $key = $site.key

    # Connect to the SharePoint Online site
    Connect-PnPOnline -Url $siteUrl -UseWebLogin

    # Remove the adaptive scope property
    Remove-PnPAdaptiveScopeProperty -Key $key -Force

    # Get the site's property bag
    $propertyBag = Get-PnPPropertyBag

    # Output the property bag
    $propertyBag
}