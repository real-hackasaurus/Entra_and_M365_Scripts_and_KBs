#The steps are below:

## Update the identity below with the hold name to search
$Hold = Get-CaseHoldPolicy -Identity "Hold Name" -DistributionDetail 
$SPO = $Hold.SharepointLocation
## UPdate below with SPO site to search
$SPO | Where{($_.Name -like "*/SPO-SITE/*") -or ($_.Name -like "*/SPO-SITE/*") -or ($_.Name -like "*/SPO-SITE/*”)} | Select Name


#Then we copy the output of this list into the following:

## Update the identity below with the hold name to search
Set-CaseHoldPolicy -Identity "Hold Name" -RemoveSharePointLocation “SPO URL”,”SPO URL”,”SPO URL”


## Update below with any custodian holds that we need to search, full custodian hold with id
$Hold = Get-CaseHoldPolicy -Identity "CustodianHold-b627ef86afd64798-0638222667106043239" -DistributionDetail 
$SPO = $Hold.SharepointLocation
## UPdate below with SPO site to search
$SPO | Where{($_.Name -like "*/SPO-SITE/*") -or ($_.Name -like "*/SPO-SITE/*") -or ($_.Name -like "*/SPO-SITE/*”)} | Select Name

## UPdate below with SPO site to search
Set-CaseHoldPolicy -Identity "Hold Name" -RemoveSharePointLocation “SPO URL”,”SPO URL”,”SPO URL”