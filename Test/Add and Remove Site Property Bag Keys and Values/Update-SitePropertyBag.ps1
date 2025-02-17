Import-Module PnP.PowerShell
# Load the CSV file
$csvPath = "C:\Users\wesle\OneDrive\Documents\GitHub\Azure_and_O365_Scripts_and_KBs\Test\Add and Remove Site Property Bag Keys and Values\CSV_Template.csv"
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
