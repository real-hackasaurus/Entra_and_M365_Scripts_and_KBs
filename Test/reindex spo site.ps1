# Define the site URL
$siteUrl = "https://m365x34890247.sharepoint.com/"

# Connect to the SharePoint Online site
Connect-PnPOnline -Url $siteUrl -UseWebLogin

# Reindex the site
$site = Get-PnPSite
$site.ReIndex()

# Confirm the reindexing request
Write-Output "Reindexing request for site '$siteUrl' has been submitted."

#TODO check this site for maybe more examples to test https://pnp.github.io/script-samples/spo-reindex-sites/README.html?tabs=pnpps