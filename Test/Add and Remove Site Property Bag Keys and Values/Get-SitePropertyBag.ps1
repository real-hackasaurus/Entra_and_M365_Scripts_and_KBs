<#
    -Created by: Wesley Blackwell
    -Date last updated: 2/17/2025

    -Overview:
        This script checks the property bag of SharePoint Online sites based on a CSV template and exports the results to a text file.
        The CSV file should contain the site URLs.

    -Instructions:
        1. Ensure you have the PnP.PowerShell module installed.
        2. Create a CSV file with the following structure:
            SiteURL
            https://yourtenant.sharepoint.com/sites/Site1
            https://yourtenant.sharepoint.com/sites/Site2
        3. Update the $csvPath variable in the script to point to the location of your CSV file.
        4. Update the $outputPath variable in the script to point to the desired location of the output text file.
        5. Run the script in PowerShell.

    -Permissions Needed:
        - SharePoint Admin or Site Collection Admin

    -Modules Needed:
        - PnP.PowerShell

    -Notes:
        - Ensure you have the necessary permissions to check properties in the property bag in SharePoint Online.
#>

# Check if PnP.PowerShell module is installed and imported
if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
    Install-Module -Name PnP.PowerShell -Force
}
Import-Module PnP.PowerShell

# Load the CSV file
$csvPath = "C:\Users\wesle\OneDrive\Documents\GitHub\Azure_and_O365_Scripts_and_KBs\Test\Add and Remove Site Property Bag Keys and Values\CSV_Template.csv"
$outputPath = "C:\Users\wesle\OneDrive\Documents\GitHub\Azure_and_O365_Scripts_and_KBs\Test\Add and Remove Site Property Bag Keys and Values\PropertyBagResults.txt"
$sites = Import-Csv -Path $csvPath

# Initialize the output file
New-Item -Path $outputPath -ItemType File -Force

foreach ($site in $sites) {
    $siteUrl = $site.SiteURL

    try {
        # Connect to the SharePoint Online site
        Connect-PnPOnline -Url $siteUrl -UseWebLogin

        # Get the site's property bag
        $propertyBag = Get-PnPPropertyBag

        # Write the site URL and property bag to the output file
        Add-Content -Path $outputPath -Value "Site URL: $siteUrl"
        Add-Content -Path $outputPath -Value "-------------------------------------------------------------------------------------------"
        Add-Content -Path $outputPath -Value ($propertyBag | Out-String)
        Add-Content -Path $outputPath -Value "`n"

        # Disconnect from the site
        Disconnect-PnPOnline

        Write-Host "Property bag for site $siteUrl has been written to the output file."
    } catch {
        Write-Host "An error occurred while processing site $siteUrl"
        Add-Content -Path $outputPath -Value "An error occurred while processing site $siteUrl"
    }
}

Write-Host "Property bag check completed and results exported to $outputPath."