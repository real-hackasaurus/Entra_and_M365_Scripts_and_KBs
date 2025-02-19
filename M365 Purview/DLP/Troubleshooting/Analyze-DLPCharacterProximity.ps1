<#
.SYNOPSIS
Connects to Exchange Online, extracts text from an input file, classifies it, and writes the results to an output file.

.DESCRIPTION
This script connects to Exchange Online using the provided User Principal Name (UPN), reads content from the specified input file, extracts text, classifies the text, and writes the classification results to the specified output file.

.INSTRUCTIONS
1. Ensure you have the ExchangeOnlineManagement module installed.
2. Connect to your Office 365 using the Connect-ExchangeOnline cmdlet.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
You need to have sufficient permissions to connect to Exchange Online and perform text extraction and classification.

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETER UserPrincipalName
The UPN for connecting to Exchange Online.

.PARAMETER FilePath
Path to the input file.

.PARAMETER OutputFile
Path for the results output file.

.EXAMPLE
.\Analyze-DLPCharacterProximity.ps1 -UserPrincipalName "user@yourdomain.com" -FilePath "C:\path\to\input.txt" -OutputFile "C:\path\to\output.txt"

This will connect to Exchange Online using the specified UPN, read content from the input file, classify the text, and write the results to the output file.

.NOTES
File Name      : Analyze-DLPCharacterProximity.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$UserPrincipalName = $env:USER_PRINCIPAL_NAME,

    [Parameter(Mandatory=$true)]
    [string]$FilePath = $env:FILE_PATH,

    [Parameter(Mandatory=$true)]
    [string]$OutputFile = $env:OUTPUT_FILE
)

// Ensure parameters are not empty
try {
    if (-not $UserPrincipalName) {
        Write-Error "UserPrincipalName parameter is empty or not set!"
        exit
    }

    if (-not $FilePath) {
        Write-Error "FilePath parameter is empty or not set!"
        exit
    }

    if (-not $OutputFile) {
        Write-Error "OutputFile parameter is empty or not set!"
        exit
    }
} catch {
    Write-Error "Error checking parameters: $_"
    exit
}

// Check if the ExchangeOnlineManagement module is installed and imported
try {
    if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
        Install-Module -Name ExchangeOnlineManagement -Force
    }
    Import-Module ExchangeOnlineManagement
} catch {
    Write-Error "Failed to install or import ExchangeOnlineManagement module: $_"
    exit
}

// Connect to Exchange Online
try {
    Connect-ExchangeOnline -UserPrincipalName $UserPrincipalName
} catch {
    Write-Error "Failed to connect to Exchange Online: $_"
    exit
}

// Attempt to retrieve content from file
try {
    $content = Get-Content $FilePath -Encoding Byte -ReadCount 0

    // Try alternative method if content is empty
    if (-not $content) {
        $content = ([Byte[]]$(Get-Content -Path $FilePath -Encoding Byte -ReadCount 0))
    }

    // Exit with error if no content
    if (-not $content) {
        Write-Error "Failed to read content. Check file path."
        exit
    }
} catch {
    Write-Error "Error reading content from file: $_"
    exit
}

// Extract and classify text
try {
    $extractedText = Test-TextExtraction -FileData $content -Verbose
    $results = Test-DataClassification -TextToClassify $extractedText.ExtractedResults.ExtractedStreamText
} catch {
    Write-Error "Error extracting or classifying text: $_"
    exit
}

// Prepare output and write to file
try {
    $outputText = @()
    $outputText += "===== Classification Results ====="
    $outputText += $results.ClassificationResults
    $outputText += "`n===== Full Results ====="
    $outputText += $results | Out-String
    $outputText | Set-Content -Path $OutputFile
} catch {
    Write-Error "Error writing results to output file: $_"
    exit
}
