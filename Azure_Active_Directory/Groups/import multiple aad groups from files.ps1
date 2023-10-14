# Authenticate with Azure AD
Connect-AzureAD

# Define the path where the txt files are stored
$txtFolderPath = "C:\output\"

# Retrieve all txt files from the folder
$txtFiles = Get-ChildItem -Path $txtFolderPath -Filter *.txt

foreach ($txtFile in $txtFiles) {
    # Derive group name from file name (without extension)
    $groupName = [System.IO.Path]::GetFileNameWithoutExtension($txtFile.Name)

    # Get the group
    $group = Get-AzureADGroup -SearchString $groupName
    
    # If the group exists
    if($null -ne $group) {
        # Import user principal names from txt file
        $userPrincipalNames = Get-Content -Path $txtFile.FullName
        
        foreach ($userPrincipalName in $userPrincipalNames) {
            # Get the user
            $user = Get-AzureADUser -ObjectId $userPrincipalName

            # If the user exists
            if($null -ne $user){
                try {
                    # Add user to group
                    Add-AzureADGroupMember -ObjectId $group.ObjectId -RefObjectId $user.ObjectId
                    Write-Host "Added $userPrincipalName to $groupName."
                }
                catch {
                    Write-Warning "Failed to add $userPrincipalName to $groupName. Error: $_"
                }
            }
            else{
                Write-Warning "User '$userPrincipalName' not found."
            }
        }
    }
    else{
        Write-Warning "Group '$groupName' not found."
    }
}