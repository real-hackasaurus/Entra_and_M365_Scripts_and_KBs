<#
.SYNOPSIS
This script copies members from one Azure AD group to another.

.DESCRIPTION
Using the AzureAD or AzureADPreview module, this script fetches all the user members from a source Azure AD group and adds them to a target Azure AD group. 
If a member already exists in the target group, it will skip that member and continue with others.

.INSTRUCTIONS
1. Ensure you have the AzureAD or AzureADPreview module installed.
2. Connect to your Azure AD using the Connect-AzureAD cmdlet.
3. Run the script with the required parameters.

.PERMISSIONS
You need to have sufficient permissions to read members from the source group and add members to the target group in Azure AD.

.MODULES NEEDED
- AzureAD or AzureADPreview

.PARAMETER SourceGroupName
The display name of the source Azure AD group from which members will be copied.

.PARAMETER TargetGroupName
The display name of the target Azure AD group to which members will be added.

.EXAMPLE
.\Copy-AADGroupMembers.ps1 -SourceGroupName "Source Group Name" -TargetGroupName "Target Group Name"

This will copy all user members from "Source Group Name" to "Target Group Name".
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$SourceGroupName = $env:SOURCE_GROUP_NAME,

    [Parameter(Mandatory=$true)]
    [string]$TargetGroupName = $env:TARGET_GROUP_NAME
)

# Ensure parameters are not empty
if (-not $SourceGroupName) {
    Write-Error "SourceGroupName parameter is empty or not set!"
    exit
}

if (-not $TargetGroupName) {
    Write-Error "TargetGroupName parameter is empty or not set!"
    exit
}

try {
    # Connect to Azure AD
    Connect-AzureAD
} catch {
    Write-Error "Failed to connect to Azure AD: $_"
    exit
}

try {
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
} catch {
    Write-Error "Error retrieving groups: $_"
    exit
}

try {
    # Fetch members from the source group
    $sourceMembers = Get-AzureADGroupMember -ObjectId $sourceGroup.ObjectId -All $true | Where-Object {$_.ObjectType -eq "User"}
} catch {
    Write-Error "Error fetching members from source group: $_"
    exit
}

try {
    # Add members to the target group
    foreach ($member in $sourceMembers) {
        try {
            # Check if user is already a member of the target group
            $isMemberAlready = Get-AzureADGroupMember -ObjectId $targetGroup.ObjectId -All $true | Where-Object {$_.ObjectId -eq $member.ObjectId}
            
            if (-not $isMemberAlready) {
                Add-AzureADGroupMember -ObjectId $targetGroup.ObjectId -RefObjectId $member.ObjectId
                Write-Output "Added $($member.DisplayName) to $TargetGroupName"
            } else {
                Write-Output "$($member.DisplayName) is already a member of $TargetGroupName"
            }
        } catch {
            Write-Error "Error adding member $($member.DisplayName) to target group: $_"
        }
    }
} catch {
    Write-Error "Error processing members: $_"
}
