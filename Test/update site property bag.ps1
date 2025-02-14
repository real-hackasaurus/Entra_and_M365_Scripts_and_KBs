Import-Module PnP.PowerShell

# Define variables
$key = "BulkSac"
$value = "TestVal1"

# Connect to the SharePoint Online site
$siteUrl = "https://m365x34890247.sharepoint.com/sites/SACTestSite1/"
Connect-PnPOnline -Url $siteUrl -UseWebLogin

# Set the adaptive scope property
Set-PnPAdaptiveScopeProperty -Key $key -Value $value

#Remove-PnPAdaptiveScopeProperty -Key $key -Force

# Confirm the property is set
Write-Output 

# Get the site's property bag
$propertyBag = Get-PnPPropertyBag

# Output the property bag
$propertyBag


#TODO location where the instructions for this testing are: https://techcommunity.microsoft.com/blog/microsoft-security-blog/using-custom-sharepoint-site-properties-to-apply-microsoft-365-retention-with-ad/3133970
#TODO check back on SACTestSite1 to see if the property is set, map the crawled property to RefinableString01
#TODO can check if the sac adaptive scope query will work by going to https://m365x34890247.sharepoint.com/search and testing this query RefinableString01=TestVal1. Do this after the values are set

#TODO build this into a script that takes an import csv template. one column for the site url and another that is the key to set and the value to set it to.
    #TODO a lot of this might already be done here: https://brenle.github.io/MIGScripts/spo-od/adaptive-scopes-propertybag-scripts/
#TODO build the reverse of the above script so that it can remove the property bag values
#TODO build a script that can set the crawled property mappings to the refinable strings
#TODO build a script that can set the adaptive scope query to the refinable strings
