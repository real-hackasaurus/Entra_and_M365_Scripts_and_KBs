Import-Module ExchangeOnlineManagement
Connect-IPPSSession -UserPrincipalName yourupn@domain.com

Start-Transcript
#Cmdlets will be downloaded when the session is active. 
Get-Label | fl
Get-LabelPolicy | fl
Stop-Transcript