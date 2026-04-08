<#
.SYNOPSIS
This script updates Teams channel locations in retention policies in Microsoft 365 Purview based on the information provided in a CSV file.

.DESCRIPTION
The script connects to the Security & Compliance PowerShell, reads retention policy details from a CSV file,
and updates Teams channel locations in existing retention policies in Microsoft 365 Purview. The CSV file should contain columns for PolicyName,
Action (Add/Remove), Exception (Yes/No), TeamsChannelLocation, and TeamsChatLocation.

.INSTRUCTIONS
1. Ensure you have the ExchangeOnlineManagement module installed.
2. Create a CSV file with columns: PolicyName, Action, Exception, TeamsChannelLocation, TeamsChatLocation.
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
.\Update-TeamsChannelLocation.ps1 -csvPath "C:\Path\To\Your\CSV\values.csv" -adminUPN "admin@yourdomain.onmicrosoft.com"

.NOTES
File Name      : Update-TeamsChannelLocation.ps1
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
        $teamsChannelLocations = @()
        $teamsChatLocations = @()

        # Collect locations
        foreach ($policy in $group.Group) {
            if ($policy.TeamsChannelLocation) {
                $teamsChannelLocations += $policy.TeamsChannelLocation
            }
            if ($policy.TeamsChatLocation) {
                $teamsChatLocations += $policy.TeamsChatLocation
            }
        }

        # Build the command dynamically based on available locations
        $command = "Set-RetentionCompliancePolicy -Identity `"$policyName`""

        if ($exception -eq "Yes") {
            if ($teamsChannelLocations) {
                $command += " -AddTeamsChannelLocationException `"$($teamsChannelLocations -join '","')`"" 
            }
            if ($teamsChatLocations) {
                $command += " -AddTeamsChatLocationException `"$($teamsChatLocations -join '","')`"" 
            }
        }

        if ($action -eq "Add") {
            if ($teamsChannelLocations) {
                $command += " -AddTeamsChannelLocation `"$($teamsChannelLocations -join '","')`"" 
            }
            if ($teamsChatLocations) {
                $command += " -AddTeamsChatLocation `"$($teamsChatLocations -join '","')`"" 
            }
        }

        if ($action -eq "Remove") {
            if ($teamsChannelLocations) {
                $command += " -RemoveTeamsChannelLocation `"$($teamsChannelLocations -join '","')`"" 
            }
            if ($teamsChatLocations) {
                $command += " -RemoveTeamsChatLocation `"$($teamsChatLocations -join '","')`"" 
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
