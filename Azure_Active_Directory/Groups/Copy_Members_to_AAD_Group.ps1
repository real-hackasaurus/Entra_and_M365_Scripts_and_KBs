<#
.SYNOPSIS
This script copies members from one Azure AD group to another.

.DESCRIPTION
Using the AzureAD or AzureADPreview module, this script fetches all the user members from a source Azure AD group and adds them to a target Azure AD group. 
If a member already exists in the target group, it will skip that member and continue with others.

.PARAMETER SourceGroupName
The display name of the source Azure AD group from which members will be copied.

.PARAMETER TargetGroupName
The display name of the target Azure AD group to which members will be added.

.EXAMPLE
.\Copy_Members_to_AAD_Group.ps1 -SourceGroupName "Source Group Name" -TargetGroupName "Target Group Name"

This will copy all user members from "Source Group Name" to "Target Group Name".
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$SourceGroupName,

    [Parameter(Mandatory=$true)]
    [string]$TargetGroupName
)

# Connect to Azure AD
Connect-AzureAD

# Get the Source and Target Groups
$sourceGroup = Get-AzureADGroup -Filter "DisplayName eq '$SourceGroupName'"
$targetGroup = Get-AzureADGroup -Filter "DisplayName eq '$TargetGroupName'"

if (-not $sourceGroup) {
    Write-Error "Source group '$SourceGroupName' not found!"
    exit
}

if (-not $targetGroup) {
    Write-Error "Target group '$TargetGroupName' not found!"
    exit
}

# Fetch members from the source group
$sourceMembers = Get-AzureADGroupMember -ObjectId $sourceGroup.ObjectId -All $true | Where-Object {$_.ObjectType -eq "User"}

# Add members to the target group
foreach ($member in $sourceMembers) {
    # Check if user is already a member of the target group
    $isMemberAlready = Get-AzureADGroupMember -ObjectId $targetGroup.ObjectId -All $true | Where-Object {$_.ObjectId -eq $member.ObjectId}
    
    if (-not $isMemberAlready) {
        Add-AzureADGroupMember -ObjectId $targetGroup.ObjectId -RefObjectId $member.ObjectId
        Write-Output "Added $($member.DisplayName) to $TargetGroupName"
    } else {
        Write-Output "$($member.DisplayName) is already a member of $TargetGroupName"
    }
}
