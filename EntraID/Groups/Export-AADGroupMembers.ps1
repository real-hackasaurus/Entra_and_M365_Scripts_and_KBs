<#
    -Created by: Wesley Blackwell
    -Date last updated: 5/9/2022

    -Overview:
        Just exports users of group by group id

    -Permissions Needed:
        -Global Admin (confirmed)

    -Modules Needed:
        -AzureAD

    -Notes:
        -
#>

Import-Module AzureAD

Connect-AzureAD
$groupId = "your-group-id-here"
Get-AzureADGroupMember -ObjectId $groupId | Export-Csv -Path .\Group.csv -NoTypeInformation