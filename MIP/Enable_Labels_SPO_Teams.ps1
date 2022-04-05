<#

    -Created by: Wesley Blackwell
    -Date last updated: 4/5/2022

    -Overview: 
        This script is meant to enable the newer capabilities of sensitivity labels in SharePoint and OneDrive as well as enable sensitivity labels for use in Teams, M365 groups, and SharePoint sites.
    -Overview doc, enable new SPO features: https://docs.microsoft.com/en-us/microsoft-365/compliance/sensitivity-labels-sharepoint-onedrive-files?view=o365-worldwide
    -Overview doc, enable sensitivity labels: https://docs.microsoft.com/en-us/microsoft-365/compliance/sensitivity-labels-teams-groups-sites?view=o365-worldwide

    -Permissions Needed:
        -Global Admin: EnableMIPLabelsForContainers, EnableNewCapabilitiesSPOOD
        -SharePoint Admin: EnableNewCapabilitiesSPOOD
#>

Function InstallModule {
    Install-Module -Name Microsoft.Online.SharePoint.PowerShell #Used: EnableNewCapabilitiesSPOOD
    Install-Module AzureADPreview #Used: EnableMIPLabelsForContainers
    Install-Module ExchangeOnlineManagement #Used: SyncLabels
    
}

Function EnableNewCapabilitiesSPOOD{
<#
    -Permissions: global administrator or SharePoint admin privileges in Microsoft 365
    -Docs: 
        -Use PowerShell to enable support for sensitivity labels: https://docs.microsoft.com/en-us/microsoft-365/compliance/sensitivity-labels-sharepoint-onedrive-files?view=o365-worldwide#use-powershell-to-enable-support-for-sensitivity-labels
#>
    Update-Module -Name Microsoft.Online.SharePoint.PowerShell
    #UPDATE URL BELOW FOR ORG
    Connect-SPOService -Url https://contoso-admin.sharepoint.com
    Set-SPOTenant -EnableAIPIntegration $true
}

Function EnableMIPLabelsForContainers {
<#

    -Permissions: Global Admin
    -Docs:
        -Instructions of steps: https://docs.microsoft.com/en-us/microsoft-365/compliance/sensitivity-labels-teams-groups-sites?view=o365-worldwide#how-to-enable-sensitivity-labels-for-containers-and-synchronize-labels
        -Instructions for powershell for sensitivity labels: https://docs.microsoft.com/en-us/azure/active-directory/enterprise-users/groups-assign-sensitivity-labels

#>
    Import-Module AzureADPreview
    Connect-AzureAD
    $grpUnifiedSetting = (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ)
    $Setting = $grpUnifiedSetting
    $grpUnifiedSetting.Values
    $Setting["EnableMIPLabels"] = "True"
    $Setting.Values
    Set-AzureADDirectorySetting -Id $grpUnifiedSetting.Id -DirectorySetting $Setting
}

Function SyncLabels {
<#

    -NOTES: Basic auth may be required to run the following commands.
    -Docs: 
        -Connect to s&c powershell: https://docs.microsoft.com/en-us/powershell/exchange/connect-to-scc-powershell?view=exchange-ps#connect-to-security--compliance-powershell-using-mfa-and-modern-authentication
        - 
#>
    Import-Module ExchangeOnlineManagement
    $UserCredential = Get-Credential
    Connect-IPPSSession -Credential $UserCredential
    Execute-AzureAdLabelSync
}

#Step 1: Enable new capabilities in SPO and OD
EnableNewCapabilitiesSPOOD

#Step 2: Insatll any modules needed
InstallModule

#Step 3: Update O365 Containers to enable MIP Labels
EnableMIPLabelsForContainers

#Step 4: Sync any existing labels so that they can be used
SyncLabels