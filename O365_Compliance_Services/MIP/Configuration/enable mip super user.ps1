#If needed, install module with below
Install-Module -Name AIPService -Force -AllowClobber

Connect-AipService

#KB artilce for below: https://learn.microsoft.com/en-us/powershell/module/aipservice/enable-aipservicesuperuserfeature?view=azureipps
#Only needs Compliance Admin to run
Enable-AipServiceSuperUserFeature 

$users = @('user1@example.com', 'user2@example.com', 'user3@example.com')
foreach ($user in $users) {
    Add-AipServiceSuperUser -EmailAddress $user
}
