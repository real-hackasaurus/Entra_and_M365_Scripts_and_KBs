<#
.SYNOPSIS
This script connects to the Exchange Online Management and syncs MIP labels.

.DESCRIPTION
The script imports the ExchangeOnlineManagement module, connects to the IPPS session using the provided UPN, and then executes the Azure AD label sync.

.PARAMETER UPN
User Principal Name (UPN) used to connect to the IPPS session.

.EXAMPLE
.\Sync_Labels.ps1 -UPN user@contoso.com

.NOTES
Make sure to have the ExchangeOnlineManagement module installed and that you have the required permissions to execute the commands.

#>

param (
    [Parameter(Mandatory=$true)]
    [string]$UPN
)

# Import Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Connect to IPPS session using the provided UPN
Connect-IPPSSession -UserPrincipalName $UPN

# Execute Azure AD label sync
Execute-AzureAdLabelSync