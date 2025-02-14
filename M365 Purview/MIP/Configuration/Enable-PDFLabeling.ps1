<#

    -Created by: Wesley Blackwell
    -Date last updated: 6/21/2022

    -Overview:
        This script is meant to enable the newer capabilities of PDFs. Currently, there is only the ability to turn on the auto-inherit permissions from the email for PDFs.
    -Overview doc, Are PDF file attachments supported: https://docs.microsoft.com/en-us/microsoft-365/compliance/ome-faq?view=o365-worldwide#are-pdf-file-attachments-supported-

    -Permissions Needed:
        -Global Admin: Set-IRMConfiguration
        -Security Admin: NEED TO TEST

    -Modules Needed:
        -ExchangeOnlineManagement

    -Notes:
        -Could take up to 24 hours for some changes to show up
#>

Import-Module ExchangeOnlineManagement

#UPDATE: BELOW WITH ADMIN ACCOUNT
Connect-ExchangeOnline -UserPrincipalName user@contoso.com

Set-IRMConfiguration -EnablePdfEncryption $true