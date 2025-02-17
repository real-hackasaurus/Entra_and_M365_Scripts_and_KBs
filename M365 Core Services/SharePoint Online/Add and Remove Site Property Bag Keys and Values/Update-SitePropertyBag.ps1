<#
    -Created by: Wesley Blackwell
    -Date last updated: 2/17/2025

    -Overview:
        This script updates specified properties in the property bag of SharePoint Online sites based on a CSV template.
        The CSV file should contain the site URLs, keys, and values of the properties to be updated.

    -Instructions:
        1. Ensure you have the PnP.PowerShell module installed.
        2. Create a CSV file with the following structure:
            SiteURL,key,value
            https://yourtenant.sharepoint.com/sites/Site1,Key1,Value1
            https://yourtenant.sharepoint.com/sites/Site2,Key2,Value2
        3. Update the $csvPath variable in the script to point to the location of your CSV file.
        4. Run the script in PowerShell.

    -Permissions Needed:
        - SharePoint Admin or Site Collection Admin

    -Modules Needed:
        - PnP.PowerShell

    -Notes:
        - Ensure you have the necessary permissions to update properties in the property bag in SharePoint Online.
#>

Import-Module PnP.PowerShell

# Load the CSV file
$csvPath = "C:\path\to\your\csvfile.csv"
$sites = Import-Csv -Path $csvPath

foreach ($site in $sites) {
    $siteUrl = $site.SiteURL
    $key = $site.key
    $value = $site.value

    # Connect to the SharePoint Online site
    Connect-PnPOnline -Url $siteUrl -UseWebLogin

    # Set the adaptive scope property
    Set-PnPAdaptiveScopeProperty -Key $key -Value $value

    # Get the site's property bag
    $propertyBag = Get-PnPPropertyBag

    # Output the property bag
    $propertyBag
}