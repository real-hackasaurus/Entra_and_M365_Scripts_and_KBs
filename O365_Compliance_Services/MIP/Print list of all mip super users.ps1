#If needed, install module with below
Install-Module -Name AIPService -Force -AllowClobber

Connect-AipService

$superUsers = Get-AipServiceSuperUser
$superUsers | ForEach-Object {
    Write-Output $_
}