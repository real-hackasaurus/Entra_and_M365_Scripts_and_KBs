###If needed, install the modules below
#Install-Module -Name AzureAD
# or
#Install-Module -Name AzureADPreview

# Connect to Azure AD
Connect-AzureAD

# Get the Source and Target Groups
$sourceGroupName = "Source Group Name"
$targetGroupName = "Target Group Name"

$sourceGroup = Get-AzureADGroup -Filter "DisplayName eq '$sourceGroupName'"
$targetGroup = Get-AzureADGroup -Filter "DisplayName eq '$targetGroupName'"

if (-not $sourceGroup) {
    Write-Error "Source group '$sourceGroupName' not found!"
    exit
}

if (-not $targetGroup) {
    Write-Error "Target group '$targetGroupName' not found!"
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
        Write-Output "Added $($member.DisplayName) to $targetGroupName"
    } else {
        Write-Output "$($member.DisplayName) is already a member of $targetGroupName"
    }
}
