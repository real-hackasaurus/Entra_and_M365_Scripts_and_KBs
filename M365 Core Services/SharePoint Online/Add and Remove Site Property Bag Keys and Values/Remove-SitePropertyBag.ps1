<#
    -Created by: Wesley Blackwell
    -Date last updated: 2/17/2025

    -Overview:
        This script removes specified properties from the property bag of SharePoint Online sites based on a CSV template.
        The CSV file should contain the site URLs and the keys of the properties to be removed.

    -Instructions:
        1. Ensure you have the PnP.PowerShell module installed.
        2. Create a CSV file with the following structure:
            SiteURL,key
            https://yourtenant.sharepoint.com/sites/Site1,Key1
            https://yourtenant.sharepoint.com/sites/Site2,Key2
        3. Update the $csvPath variable in the script to point to the location of your CSV file.
        4. Run the script in PowerShell.

    -Permissions Needed:
        - SharePoint Admin or Site Collection Admin

    -Modules Needed:
        - PnP.PowerShell

    -Notes:
        - Ensure you have the necessary permissions to remove properties from the property bag in SharePoint Online.
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