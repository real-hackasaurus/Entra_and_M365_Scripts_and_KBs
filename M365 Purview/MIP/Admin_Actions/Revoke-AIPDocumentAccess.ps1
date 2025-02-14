<#
.SYNOPSIS
This script connects to the Azure Information Protection (AIP) service and revokes access to a specific document based on the content name and other optional criteria.

.DESCRIPTION
The script performs the following actions:
1. Imports the AIPService module.
2. Connects to the AIP service.
3. Fetches the document and content ID based on the provided content name and optional criteria.
4. Revokes access to the document using the fetched content ID and the provided issuer name.

.PARAMETERS
-ContentName: Name of the document for which you want to revoke access.
-IssuerName: Name of the issuer to use for revocation.
-FromTime: (Optional) The starting time frame to search logs.
-ToTime: (Optional) The ending time frame to search logs.
-Owner: (Optional) The owner of the document.

.EXAMPLE
.\Revoke_Access_To_Documents.ps1 -ContentName "Doc1.docx" -IssuerName "admin@M365x248674.onmicrosoft.com" -FromTime "06/01/2022 00:00:00" -ToTime "06/25/2022 04:00:59"

.NOTES
Prerequisite   : AIPService Module
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ContentName,

    [Parameter(Mandatory=$true)]
    [string]$IssuerName,

    [Parameter(Mandatory=$false)]
    [string]$FromTime,

    [Parameter(Mandatory=$false)]
    [string]$ToTime,

    [Parameter(Mandatory=$false)]
    [string]$Owner
)

# Import AIPService module
Import-Module AIPService

# Connect to AIP service
Connect-AipService

# Construct the Get-AipServiceDocumentLog command with optional parameters
$commandParams = @{
    ContentName = $ContentName
}
if ($FromTime) { $commandParams["FromTime"] = $FromTime }
if ($ToTime) { $commandParams["ToTime"] = $ToTime }
if ($Owner) { $commandParams["Owner"] = $Owner }

$contentLog = Get-AipServiceDocumentLog @commandParams

if($null -eq $contentLog) {
    Write-Error "Unable to find document with the given criteria"
    exit 1
}

$contentId = $contentLog.ContentId

# Revoke access to the document
Set-AipServiceDocumentRevoked -ContentId $contentId -IssuerName $IssuerName