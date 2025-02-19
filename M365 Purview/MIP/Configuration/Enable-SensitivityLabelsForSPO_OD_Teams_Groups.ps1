<#
.SYNOPSIS
This script enables the newer capabilities of sensitivity labels in SharePoint and OneDrive as well as enables sensitivity labels for use in Teams, M365 groups, and SharePoint sites.

.DESCRIPTION
The script performs the following actions:
1. Installs necessary modules.
2. Enables new capabilities in SharePoint Online (SPO) and OneDrive (OD).
3. Updates O365 Containers to enable MIP Labels.
4. Syncs any existing labels so that they can be used.

.INSTRUCTIONS
1. Ensure you have the necessary permissions to enable sensitivity labels.
2. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
3. Run the script using the provided examples or your own parameters.

.PERMISSIONS NEEDED
- Global Administrator: EnableMIPLabelsForContainers, EnableNewCapabilitiesSPOOD, SyncLabels
- SharePoint Administrator: EnableNewCapabilitiesSPOOD
- Security Administrator: SyncLabels

.MODULES NEEDED
- Microsoft.Online.SharePoint.PowerShell
- AzureADPreview
- ExchangeOnlineManagement

.PARAMETERS
-URL: The specific URL for SharePoint Online (SPO) integration.
-UPN: The User Principal Name (UPN) for administrative actions.

.EXAMPLES
.\Enable-SensitivityLabelsForSPO_OD_Teams_Groups.ps1 -URL "https://contoso-admin.sharepoint.com" -UPN "admin@contoso.com"

.NOTES
- Ensure the necessary modules are installed.
- Changes may take up to 24 hours to show up.
- Ensure any labels for "Groups & sites" are enabled under Label -> Scope.
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$URL = $env:URL,

    [Parameter(Mandatory=$true)]
    [string]$UPN = $env:UPN
)

# Validate parameters
if (-not $URL) {
    Write-Error "URL parameter is required."
    exit 1
}
if (-not $UPN) {
    Write-Error "UPN parameter is required."
    exit 1
}

function InstallModule {
    try {
        Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force -ErrorAction Stop
        Install-Module -Name AzureADPreview -Force -ErrorAction Stop
        Install-Module -Name ExchangeOnlineManagement -Force -ErrorAction Stop
    } catch {
        Write-Error "Failed to install necessary modules: $_"
        exit 1
    }
}

function EnableNewCapabilitiesSPOOD {
    try {
        Update-Module -Name Microsoft.Online.SharePoint.PowerShell -ErrorAction Stop
        Import-Module Microsoft.Online.SharePoint.PowerShell -ErrorAction Stop
        Connect-SPOService -Url $URL -ErrorAction Stop
        Set-SPOTenant -EnableAIPIntegration $true -ErrorAction Stop
        Write-Output "New capabilities in SPO and OD enabled successfully."
    } catch {
        Write-Error "Failed to enable new capabilities in SPO and OD: $_"
        exit 1
    }
}

function EnableMIPLabelsForContainers {
    try {
        Import-Module AzureADPreview -ErrorAction Stop
        Connect-AzureAD -ErrorAction Stop
        $grpUnifiedSetting = (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ)
        $Setting = $grpUnifiedSetting
        $Setting["EnableMIPLabels"] = "True"
        Set-AzureADDirectorySetting -Id $grpUnifiedSetting.Id -DirectorySetting $Setting -ErrorAction Stop
        Write-Output "MIP Labels for Containers enabled successfully."
    } catch {
        Write-Error "Failed to enable MIP Labels for Containers: $_"
        exit 1
    }
}

function SyncLabels {
    try {
        Import-Module ExchangeOnlineManagement -ErrorAction Stop
        Connect-IPPSSession -UserPrincipalName $UPN -ErrorAction Stop
        Execute-AzureAdLabelSync -ErrorAction Stop
        Write-Output "Labels synced successfully."
    } catch {
        Write-Error "Failed to sync labels: $_"
        exit 1
    }
}

# Step 1: Install any modules needed
InstallModule

# Step 2: Enable new capabilities in SPO and OD
EnableNewCapabilitiesSPOOD

# Step 3: Update O365 Containers to enable MIP Labels
EnableMIPLabelsForContainers

# Step 4: Sync any existing labels so that they can be used
SyncLabels