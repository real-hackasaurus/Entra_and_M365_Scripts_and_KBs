<#

    -Created by: Wesley Blackwell
    -Date last updated: 4/5/2022

#>

#permissions needed global admin

#region InstallModule

function InstallModule {
    Install-Module AzureADPreview
    Install-Module ExchangeOnlineManagement
}

#endregion

#region EnableMIPLabelsForContainers

<#

    -Permissions: Global Admin

#>

Function EnableMIPLabelsForContainers {
    Import-Module AzureADPreview
    Connect-AzureAD
    $grpUnifiedSetting = (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ)
    $Setting = $grpUnifiedSetting
    $grpUnifiedSetting.Values
    $Setting["EnableMIPLabels"] = "True"
    $Setting.Values
    Set-AzureADDirectorySetting -Id $grpUnifiedSetting.Id -DirectorySetting $Setting
}

#endregion

#region SyncLabels

<#

    -NOTES: Basic auth may be required to run the following commands.

#>

Function SyncLabels {
    Import-Module ExchangeOnlineManagement
    $UserCredential = Get-Credential
    Connect-IPPSSession -Credential $UserCredential
    Execute-AzureAdLabelSync
}

#endregion

#Step 1: Insatll any modules needed

InstallModule

#Step 2: Update O365 Containers to enable MIP Labels

EnableMIPLabelsForContainers

#Step 3: Sync any existing labels so that they can be used

SyncLabels