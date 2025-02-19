<#
.SYNOPSIS
    This script retrieves the publishing status of a specified retention label policy in Microsoft 365.

.DESCRIPTION
    This script connects to the Microsoft 365 Security & Compliance Center and retrieves information about the specified retention label policy.
    The script outputs the status of the policy.

.PREREQUISITES
    1. Install the Exchange Online Management module:
       Install-Module -Name ExchangeOnlineManagement -Force -AllowClobber
    2. Ensure you have the necessary permissions to connect to the Microsoft 365 Security & Compliance Center.
    3. Replace the placeholder values (e.g., admin account, retention label policy) with your actual values.

.INSTRUCTIONS
    1. Open PowerShell with administrative privileges.
    2. Run the script.
    3. The script will prompt you to connect to the Microsoft 365 Security & Compliance Center.
    4. After execution, the status of the retention label policy will be displayed.

.AUTHOR
    Wesley Blackwell
    Version: 1.0
    Date: 2/17/2025
#>

# Import the Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Define variables
$adminAccount = "admin@yourdomain.com"  # Replace with your admin account
$retentionLabelPolicy = "YourRetentionLabelPolicy"  # Replace with the retention label policy you want to check

# Connect to the Microsoft 365 Security & Compliance Center
Connect-IPPSSession -UserPrincipalName $adminAccount

# Get the retention label policy
$policy = Get-RetentionCompliancePolicy -Identity $retentionLabelPolicy

# Output the status of the policy
$policy | fl