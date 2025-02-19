# Check if PnP.PowerShell module is installed and imported
if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
    Install-Module -Name PnP.PowerShell -Force
}
Import-Module PnP.PowerShell

# Load the CSV file
$csvPath = "C:\Users\wesle\OneDrive\Documents\GitHub\Azure_and_O365_Scripts_and_KBs\Test\Add and Remove Site Property Bag Keys and Values\CSV_Template.csv"
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
