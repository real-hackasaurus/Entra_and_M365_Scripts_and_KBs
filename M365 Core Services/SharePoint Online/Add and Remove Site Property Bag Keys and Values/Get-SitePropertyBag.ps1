<#
.SYNOPSIS
This script checks the property bag of SharePoint Online sites based on a CSV template and exports the results to a text file.

.DESCRIPTION
Using the PnP.PowerShell module, this script connects to each SharePoint Online site listed in a CSV file, retrieves the site's property bag, and exports the results to a text file.

.INSTRUCTIONS
1. Ensure you have the PnP.PowerShell module installed.
2. Create a CSV file with the following structure:
    SiteURL
    https://yourtenant.sharepoint.com/sites/Site1
    https://yourtenant.sharepoint.com/sites/Site2
3. Update the $csvPath variable in the script to point to the location of your CSV file.
4. Update the $outputPath variable in the script to point to the desired location of the output text file.
5. Run the script in PowerShell.

.PERMISSIONS
- SharePoint Admin or Site Collection Admin

.MODULES NEEDED
- PnP.PowerShell

.EXAMPLE
.\Get-SitePropertyBag.ps1

This will read site URLs from the CSV file and export each site's property bag to the output text file.

.NOTES
File Name      : Get-SitePropertyBag.ps1
Author         : Wes Blackwell
Prerequisite   : PnP.PowerShell Module
#>

Import-Module PnP.PowerShell
# Load the CSV file
$csvPath = "C:\path\to\your\csvfile.csv"
$outputPath = "C:\path\to\output\PropertyBagResults.txt"
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