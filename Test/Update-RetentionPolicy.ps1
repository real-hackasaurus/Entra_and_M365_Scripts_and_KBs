<#
.SYNOPSIS
This script updates existing retention policies in Microsoft 365 Purview based on the information provided in a CSV file.

.DESCRIPTION
The script connects to the Security & Compliance PowerShell, reads retention policy details from a CSV file,
and updates existing retention policies in Microsoft 365 Purview. The CSV file should contain columns for PolicyName,
Action (Add/Remove), Exception (Yes/No), ExchangeLocation, SharePointLocation, OneDriveLocation, ModernGroupLocation,
SkypeLocation, TeamsChannelLocation, and PublicFolderLocation.

.INSTRUCTIONS
1. Ensure you have the ExchangeOnlineManagement module installed.
2. Create a CSV file with the required columns.
3. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
4. Run the script using the provided examples or your own parameters.

.PERMISSIONS
Ensure you have the necessary permissions to update retention policies and connect to the Security & Compliance PowerShell.

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETER csvPath
The path to the CSV file containing the retention policy details.

.PARAMETER adminUPN
The User Principal Name (UPN) of the admin account used to connect to Security & Compliance PowerShell.

.EXAMPLE
.\Update-RetentionPolicy.ps1 -csvPath "C:\Path\To\Your\CSV\values.csv" -adminUPN "admin@yourdomain.onmicrosoft.com"

.NOTES
File Name      : Update-RetentionPolicy.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

param (
    [string]$csvPath,
    [string]$adminUPN
)

# Check if necessary modules are installed
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Install-Module -Name ExchangeOnlineManagement -Force -Scope CurrentUser
}
Import-Module ExchangeOnlineManagement

try {
    # Validate parameters
    if (-not $csvPath) {
        throw "CSV path is required."
    }
    if (-not $adminUPN) {
        throw "Admin UPN is required."
    }

    # Connect to Security & Compliance PowerShell
    Connect-IPPSSession -UserPrincipalName $adminUPN

    # Import the CSV file
    $policies = Import-Csv -Path $csvPath

    # Group policies by PolicyName and Action
    $groupedPolicies = $policies | Group-Object -Property PolicyName, Action, Exception

    # Loop through each group and update it
    foreach ($group in $groupedPolicies) {
        $policyName = $group.Group[0].PolicyName
        $action = $group.Group[0].Action
        $exception = $group.Group[0].Exception

        # Initialize location arrays
        $exchangeLocations = @()
        $sharePointLocations = @()
        $oneDriveLocations = @()
        $modernGroupLocations = @()
        $skypeLocations = @()
        $teamsChannelLocations = @()
        $publicFolderLocations = @()

        # Collect locations
        foreach ($policy in $group.Group) {
            if ($policy.ExchangeLocation) {
                $exchangeLocations += $policy.ExchangeLocation
            }
            if ($policy.SharePointLocation) {
                $sharePointLocations += $policy.SharePointLocation
            }
            if ($policy.OneDriveLocation) {
                $oneDriveLocations += $policy.OneDriveLocation
            }
            if ($policy.ModernGroupLocation) {
                $modernGroupLocations += $policy.ModernGroupLocation
            }
            if ($policy.SkypeLocation) {
                $skypeLocations += $policy.SkypeLocation
            }
            if ($policy.TeamsChannelLocation) {
                $teamsChannelLocations += $policy.TeamsChannelLocation
            }
            if ($policy.PublicFolderLocation) {
                $publicFolderLocations += $policy.PublicFolderLocation
            }
        }

        # Build the command dynamically based on available locations
        $command = "Set-RetentionCompliancePolicy -Identity `"$policyName`""

        if ($exception -eq "Yes") {
            if ($exchangeLocations) {
                $command += " -AddExchangeLocationException `"$($exchangeLocations -join '","')`"" 
            }
            if ($sharePointLocations) {
                $command += " -AddSharePointLocationException `"$($sharePointLocations -join '","')`"" 
            }
            if ($oneDriveLocations) {
                $command += " -AddOneDriveLocationException `"$($oneDriveLocations -join '","')`"" 
            }
            if ($modernGroupLocations) {
                $command += " -AddModernGroupLocationException `"$($modernGroupLocations -join '","')`"" 
            }
            if ($skypeLocations) {
                $command += " -AddSkypeLocationException `"$($skypeLocations -join '","')`"" 
            }
            if ($teamsChannelLocations) {
                $command += " -AddTeamsChannelLocationException `"$($teamsChannelLocations -join '","')`"" 
            }
            if ($publicFolderLocations) {
                $command += " -AddPublicFolderLocationException `"$($publicFolderLocations -join '","')`"" 
            }
        }

        if ($action -eq "Add") {
            if ($exchangeLocations) {
                $command += " -AddExchangeLocation `"$($exchangeLocations -join '","')`"" 
            }
            if ($sharePointLocations) {
                $command += " -AddSharePointLocation `"$($sharePointLocations -join '","')`"" 
            }
            if ($oneDriveLocations) {
                $command += " -AddOneDriveLocation `"$($oneDriveLocations -join '","')`"" 
            }
            if ($modernGroupLocations) {
                $command += " -AddModernGroupLocation `"$($modernGroupLocations -join '","')`"" 
            }
            if ($skypeLocations) {
                $command += " -AddSkypeLocation `"$($skypeLocations -join '","')`"" 
            }
            if ($teamsChannelLocations) {
                $command += " -AddTeamsChannelLocation `"$($teamsChannelLocations -join '","')`"" 
            }
            if ($publicFolderLocations) {
                $command += " -AddPublicFolderLocation `"$($publicFolderLocations -join '","')`"" 
            }
        }

        if ($action -eq "Remove") {
            if ($exchangeLocations) {
                $command += " -RemoveExchangeLocation `"$($exchangeLocations -join '","')`"" 
            }
            if ($sharePointLocations) {
                $command += " -RemoveSharePointLocation `"$($sharePointLocations -join '","')`"" 
            }
            if ($oneDriveLocations) {
                $command += " -RemoveOneDriveLocation `"$($oneDriveLocations -join '","')`"" 
            }
            if ($modernGroupLocations) {
                $command += " -RemoveModernGroupLocation `"$($modernGroupLocations -join '","')`"" 
            }
            if ($skypeLocations) {
                $command += " -RemoveSkypeLocation `"$($skypeLocations -join '","')`"" 
            }
            if ($teamsChannelLocations) {
                $command += " -RemoveTeamsChannelLocation `"$($teamsChannelLocations -join '","')`"" 
            }
            if ($publicFolderLocations) {
                $command += " -RemovePublicFolderLocation `"$($publicFolderLocations -join '","')`"" 
            }
        }

        # Execute the command
        try {
            Invoke-Expression $command
            Write-Output "Retention policy '$policyName' updated successfully."
        } catch {
            Write-Error "Failed to update retention policy '$policyName': $_"
        }
    }

    # Disconnect from Security & Compliance PowerShell
    Disconnect-ExchangeOnline -Confirm:$false
} catch {
    Write-Error "An error occurred: $_"
}
