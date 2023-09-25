<#

    -Created by: Wesley Blackwell
    -Date last updated: 9/24/2023

    -Overview:
        This script can show what it looks like to the DLP service when it scans a file. 
        Can help with troubleshooting issues with sensitive information types and DLP policies

    -Permissions Needed:
        -Global Admin
        -Compliance Admin

    -Modules Needed:
        -ExchangeOnlineManagement

    -Notes:
        -Cmdlets will be downloaded when the session is active. 
        -Security permissions need to be active first. If user is not an admin, the command will just fail to execute without giving a permission error.
#>
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline -UserPrincipalName user@yourdomain.com

# Reads content from input file

$content = Get-Content '<input file path>' -Encoding Byte -ReadCount 0

 

# If the above Cmdlet doesn't work, then use below Cmdlet

$content = ([Byte[]]$(Get-Content -Path "<input file path>" -Encoding Byte -ReadCount 0))

 

# Extracts the text

$extractedText = Test-TextExtraction -FileData $content -Verbose

 

# extractedText can have different text streams. Check the extracted text for a file which contains a single text stream.

$extractedText.ExtractedResults.ExtractedStreamText

 

# Classifies extracted text

$results=Test-DataClassification -TextToClassify $extractedText.ExtractedResults.ExtractedStreamText -Organization $org

# results contain a single text stream a single text stream detected classifications for the given text stream. 
$results