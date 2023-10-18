<#
.SYNOPSIS
Sets a label policy in Exchange Online.

.DESCRIPTION
This script (Set_LabelPolicy.ps1) is designed to set a label policy in Exchange Online, specifically to retry distribution for a specified policy.

.PARAMETER UPN
User Principal Name required for connecting to Exchange Online.

.PARAMETER PolicyIdentity
Specifies the identity of the policy that you want to set.

.EXAMPLE
.\Retry_Policy_Distribution.ps1 -UPN "user@yourdomain.com" -PolicyIdentity "Demo - Policy"
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$UPN,

    [Parameter(Mandatory=$true)]
    [string]$PolicyIdentity
)

function Set-ExchangeLabelPolicy {
    # Import the ExchangeOnlineManagement module
    Import-Module ExchangeOnlineManagement

    # Connect to Exchange Online using the provided UPN
    Connect-ExchangeOnline -UserPrincipalName $UPN

    # Set the label policy with the specified identity to retry distribution
    Set-LabelPolicy -RetryDistribution -Identity $PolicyIdentity

    Write-Output "Label policy `$PolicyIdentity` set for retry distribution."
}

# Call the function
Set-ExchangeLabelPolicy