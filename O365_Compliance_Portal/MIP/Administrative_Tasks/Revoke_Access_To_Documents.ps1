<#

    -Created by: Wesley Blackwell
    -Date last updated: 6/26/2022

    -Overview:
        This script is meant to enable administrators to revoke access to documents that have been encrypted with MIP.
    -Overview doc, https://docs.microsoft.com/en-us/powershell/module/aipservice/?view=azureipps

    -Permissions Needed:
        -Global Admin (confirmed)

    -Modules Needed:
        -AIPService

    -Notes:
        -This feature is extremely tempermental. It only works under certain conditions. For instance, the owner who assigned the permissions has to have done so on a machine with the Unified Labeling Client installed and the add-in running on the Office appliaction that assigned the label.
        -This means that it will not work if it is assigned either through the browser or through the built-in client for desktop.
        -Additionally, the user revoke feature that is available for the add-in does not function appropriately and for the most part will not revoke access even though it gives a pop-up to the user saying it did.
#>

Import-Module AIPService
Connect-AipService

#Verify that the service is on, it is supposed to be on by default for all environments
#Get-AipServiceDocumentTrackingFeature

#Enable the document tracking service if it is off.
#Enable-AipServiceDocumentTrackingFeature

#Find the document and content id. Content id needed to revoke access
Get-AipServiceDocumentLog -ContentName "Doc1.docx"
#Get-AipServiceDocumentLog -ContentName "Doc1.docx" -FromTime "06/01/2022 00:00:00" -ToTime "06/25/2022 04:00:59"
#Get-AipServiceDocumentLog -ContentName "Doc1.docx" -Owner “admin@M365x248674.onmicrosoft.com” 

# Revoke the document using the content id.
Set-AipServiceDocumentRevoked -ContentId c645169b-3c06-49d9-97a5-355f0af5dd99 -IssuerName  “admin@M365x248674.onmicrosoft.com”