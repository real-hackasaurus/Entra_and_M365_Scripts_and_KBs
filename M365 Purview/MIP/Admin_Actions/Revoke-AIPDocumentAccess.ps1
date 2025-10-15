<#
.SYNOPSIS
This script connects to the Azure Information Protection (AIP) service and revokes access to a specific document based on the content name and other optional criteria.

.DESCRIPTION
The script performs the following actions:
1. Imports the AIPService module.
2. Connects to the AIP service.
3. Fetches the document and content ID based on the provided content name and optional criteria.
4. Revokes access to the document using the fetched content ID and the provided issuer name.

.INSTRUCTIONS
1. Ensure you have the necessary permissions to connect to the AIP service and revoke document access.
2. Set the required environment variables in the launch.json file or pass them as parameters when running the script.
3. Run the script using the provided examples or your own parameters.

.PERMISSIONS NEEDED
- Azure Information Protection Administrator
- Global Administrator (if required for certain actions)

.MODULES NEEDED
- AIPService

.PARAMETERS
-ContentName: Name of the document for which you want to revoke access.
-IssuerName: Name of the issuer to use for revocation.
-FromTime: (Optional) The starting time frame to search logs.
-ToTime: (Optional) The ending time frame to search logs.
-Owner: (Optional) The owner of the document.

.EXAMPLES
.\Revoke_Access_To_Documents.ps1 -ContentName "Doc1.docx" -IssuerName "admin@M365x248674.onmicrosoft.com" -FromTime "06/01/2022 00:00:00" -ToTime "06/25/2022 04:00:59"
.\Revoke_Access_To_Documents.ps1 -ContentName "Doc2.docx" -IssuerName "admin@M365x248674.onmicrosoft.com"

.NOTES
Prerequisite: AIPService Module
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ContentName = $env:CONTENT_NAME,

    [Parameter(Mandatory=$true)]
    [string]$IssuerName = $env:ISSUER_NAME,

    [Parameter(Mandatory=$false)]
    [string]$FromTime = $env:FROM_TIME,

    [Parameter(Mandatory=$false)]
    [string]$ToTime = $env:TO_TIME,

    [Parameter(Mandatory=$false)]
    [string]$Owner = $env:OWNER
)

# Validate parameters
if (-not $ContentName) {
    Write-Error "ContentName parameter is required."
    exit 1
}
if (-not $IssuerName) {
    Write-Error "IssuerName parameter is required."
    exit 1
}

# Check if AIPService module is installed
if (-not (Get-Module -ListAvailable -Name AIPService)) {
    try {
        Install-Module -Name AIPService -Force -ErrorAction Stop
    } catch {
        Write-Error "Failed to install AIPService module: $_"
        exit 1
    }
}

try {
    # Import AIPService module
    Import-Module AIPService -ErrorAction Stop
} catch {
    Write-Error "Failed to import AIPService module: $_"
    exit 1
}

try {
    # Connect to AIP service
    Connect-AipService -ErrorAction Stop
} catch {
    Write-Error "Failed to connect to AIP service: $_"
    exit 1
}

try {
    # Construct the Get-AipServiceDocumentLog command with optional parameters
    $commandParams = @{
        ContentName = $ContentName
    }
    if ($FromTime) { $commandParams["FromTime"] = $FromTime }
    if ($ToTime) { $commandParams["ToTime"] = $ToTime }
    if ($Owner) { $commandParams["Owner"] = $Owner }

    $contentLog = Get-AipServiceDocumentLog @commandParams -ErrorAction Stop

    if ($null -eq $contentLog) {
        Write-Error "Unable to find document with the given criteria"
        exit 1
    }

    $contentId = $contentLog.ContentId
} catch {
    Write-Error "Failed to fetch document log: $_"
    exit 1
}

try {
    # Revoke access to the document
    Set-AipServiceDocumentRevoked -ContentId $contentId -IssuerName $IssuerName -ErrorAction Stop
    Write-Output "Access to the document has been successfully revoked."
} catch {
    Write-Error "Failed to revoke access to the document: $_"
    exit 1
}