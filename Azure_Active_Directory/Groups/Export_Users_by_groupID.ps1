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

Connect-AzureAD
Get-AzureADGroupMember -ObjectId "166c6e59-f0ab-4e31-a3d5-86404b6b0333" | Export-Csv -Path .\Group.csv -NoTypeInformation