# Authenticate with Azure AD
Connect-AzureAD

# Example list of group names
$groupNames = @("Group1", "Group2", "Group3")

foreach ($groupName in $groupNames) {
    # Get the group
    $group = Get-AzureADGroup -SearchString $groupName

    # If the group exists
    if($null -ne $group){
        # Get the members of the group
        $groupMembers = Get-AzureADGroupMember -ObjectId $group.ObjectId 

        # Define the output file path
        $outputPath = "C:\output\$groupName.txt"

        # Export the members to the file
        $groupMembers | Select-Object UserPrincipalName | Export-Csv -Path $outputPath -NoTypeInformation
    }
    else{
        Write-Warning "Group '$groupName' not found."
    }
}
