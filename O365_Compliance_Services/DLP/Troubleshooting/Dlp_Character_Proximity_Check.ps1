<#
.SYNOPSIS
Connects to Exchange Online, extracts text from an input file, classifies it, and writes the results to an output file.

.PARAMETER UserPrincipalName
The UPN for connecting to Exchange Online.

.PARAMETER FilePath
Path to the input file.

.PARAMETER OutputFile
Path for the results output file.

.EXAMPLE
.\Dlp_Character_Proximity_Check.ps1 -UserPrincipalName "user@yourdomain.com" -FilePath "C:\path\to\input.txt" -OutputFile "C:\path\to\output.txt"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$UserPrincipalName,

    [Parameter(Mandatory=$true)]
    [string]$FilePath,

    [Parameter(Mandatory=$true)]
    [string]$OutputFile
)

# Import ExchangeOnlineManagement module and connect
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName $UserPrincipalName

# Attempt to retrieve content from file
$content = Get-Content $FilePath -Encoding Byte -ReadCount 0

# Try alternative method if content is empty
if (-not $content) {
    $content = ([Byte[]]$(Get-Content -Path $FilePath -Encoding Byte -ReadCount 0))
}

# Exit with error if no content
if (-not $content) {
    Write-Error "Failed to read content. Check file path."
    exit
}

# Extract and classify text
$extractedText = Test-TextExtraction -FileData $content -Verbose
$results = Test-DataClassification -TextToClassify $extractedText.ExtractedResults.ExtractedStreamText

# Prepare output and write to file
$outputText = @()
$outputText += "===== Classification Results ====="
$outputText += $results.ClassificationResults
$outputText += "`n===== Full Results ====="
$outputText += $results | Out-String
$outputText | Set-Content -Path $OutputFile
