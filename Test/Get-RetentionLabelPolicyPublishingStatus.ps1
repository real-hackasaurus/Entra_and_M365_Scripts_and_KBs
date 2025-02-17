Import-Module ExchangeOnlineManagement

$adminAccount = "admin@M365x34890247.onmicrosoft.com"  # Replace with your admin account
Connect-IPPSSession -UserPrincipalName $adminAccount

# Get the retention label policy
$policy = Get-RetentionCompliancePolicy -Identity "BulkSac 1 Label Policy"

# Output the status of the policy
$policy | fl
