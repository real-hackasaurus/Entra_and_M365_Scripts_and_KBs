#If needed, install module with below
Install-Module -Name AIPService -Force -AllowClobber -Repository 'psGallery'

# Need permissions activated in PIM before connecting to service
Connect-AipService

$superUsers = Get-AipServiceSuperUser
$superUsers | ForEach-Object {
    Write-Output $_
}