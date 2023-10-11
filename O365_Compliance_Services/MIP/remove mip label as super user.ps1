#Will need to insatll the Azure Unified Labeling Client to use this PowerShell Module

Import-Module AzureInformationProtection
Connect-AipService

#KB article on the command below: https://learn.microsoft.com/en-us/powershell/module/azureinformationprotection/set-aipfilelabel?view=azureipps

#This command has to be ran by an account that is both SIGNED INTO THE WORKSTATION AND HAS ACCESS TO THE LABELS IT NEEDS TO REMOVE
#Article on this issue: https://learn.microsoft.com/en-us/answers/questions/937626/error-running-set-aipfilelabel-from-azure-powershe

Set-AIPFileLabel "C:\TEMP\Document choose permission doc.docx" -RemoveLabel -JustificationMessage 'The previous label no longer applies'
