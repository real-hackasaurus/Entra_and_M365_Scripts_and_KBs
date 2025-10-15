<#
.SYNOPSIS
This script contains several commands for DLP policy and rule creation.

.DESCRIPTION
This script connects to Exchange Online using the provided User Principal Name (UPN), retrieves or sets DLP policies and rules, and performs various DLP-related operations.

.INSTRUCTIONS
1. Ensure you have the ExchangeOnlineManagement module installed.
2. Connect to your Office 365 using the Connect-IPPSSession cmdlet.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
You need to have Global Admin and Compliance Admin permissions.

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETER UserPrincipalName
The UPN for connecting to Exchange Online.

.PARAMETER PolicyName
The name of the DLP policy.

.PARAMETER RuleName
The name of the DLP rule.

.PARAMETER RuleFilePath
The file path to the rule content.

.PARAMETER EmailFilePath
The file path to the custom email content.

.EXAMPLE
.\Manage-DLPRulesAndPolicies.ps1 -UserPrincipalName "user@contoso.com" -PolicyName "My Policy Name" -RuleName "My Rule Name" -RuleFilePath "C:\TEMP\DLP_Policy\rule.txt" -EmailFilePath "C:\TEMP\DLP_Policy\email.txt"

This will connect to Exchange Online using the specified UPN, create or modify the specified DLP policy and rule, and use the provided file paths for rule and email content.

.NOTES
File Name      : Manage-DLPRulesAndPolicies.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$UserPrincipalName = $env:USER_PRINCIPAL_NAME,

    [Parameter(Mandatory=$true)]
    [string]$PolicyName = $env:POLICY_NAME,

    [Parameter(Mandatory=$true)]
    [string]$RuleName = $env:RULE_NAME,

    [Parameter(Mandatory=$true)]
    [string]$RuleFilePath = $env:RULE_FILE_PATH,

    [Parameter(Mandatory=$true)]
    [string]$EmailFilePath = $env:EMAIL_FILE_PATH
)

# Ensure parameters are not empty
try {
    if (-not $UserPrincipalName) {
        Write-Error "UserPrincipalName parameter is empty or not set!"
        exit
    }

    if (-not $PolicyName) {
        Write-Error "PolicyName parameter is empty or not set!"
        exit
    }

    if (-not $RuleName) {
        Write-Error "RuleName parameter is empty or not set!"
        exit
    }

    if (-not $RuleFilePath) {
        Write-Error "RuleFilePath parameter is empty or not set!"
        exit
    }

    if (-not $EmailFilePath) {
        Write-Error "EmailFilePath parameter is empty or not set!"
        exit
    }
} catch {
    Write-Error "Error checking parameters: $_"
    exit
}

# Check if the ExchangeOnlineManagement module is installed and imported
try {
    if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
        Install-Module -Name ExchangeOnlineManagement -Force
    }
    Import-Module ExchangeOnlineManagement
} catch {
    Write-Error "Failed to install or import ExchangeOnlineManagement module: $_"
    exit
}

# Connect to Exchange Online
try {
    Connect-IPPSSession -UserPrincipalName $UserPrincipalName
} catch {
    Write-Error "Failed to connect to Exchange Online: $_"
    exit
}

# Get a sensitive information type by name
try {
    Get-DlpSensitiveInformationType -Identity $PolicyName | Format-List
} catch {
    Write-Error "Error retrieving sensitive information type: $_"
}

# Get a list of all DLP Policies
try {
    Get-DlpCompliancePolicy
} catch {
    Write-Error "Error retrieving DLP policies: $_"
}

# Get a specific policy by name
try {
    Get-DlpCompliancePolicy -Identity $PolicyName | Format-List
} catch {
    Write-Error "Error retrieving DLP policy: $_"
}

# Get a specific rule by name
try {
    Get-DlpComplianceRule -Identity $RuleName | Format-List
} catch {
    Write-Error "Error retrieving DLP rule: $_"
}

# Same as above but output to file
try {
    Get-DlpComplianceRule -Identity $RuleName | Format-List | Out-File -FilePath "C:\TEMP\DLP_Policy\output.txt"
} catch {
    Write-Error "Error retrieving DLP rule and writing to file: $_"
}

# Create new DLP policy
try {
    New-DlpCompliancePolicy -Name $PolicyName -ExchangeLocation All -Mode TestWithoutNotifications
} catch {
    Write-Error "Error creating DLP policy: $_"
}

# Read the content of a .txt file to create a new rule
try {
    $rule = Get-Content -Path $RuleFilePath -ReadCount 0
} catch {
    Write-Error "Error reading rule file: $_"
}

# Read the content of a .txt file to create a new custom email body
try {
    $email = Get-Content -Path $EmailFilePath -ReadCount 0
} catch {
    Write-Error "Error reading email file: $_"
}

# Create new DLP rule
try {
    New-DLPComplianceRule -Name $RuleName -Policy $PolicyName `
    -AdvancedRule $rule -NotifyUser LastModifier, user@contoso.com, user2@contoso.com `
    -NotifyUserType Email -NotifyEmailCustomText $email -Priority 0
} catch {
    Write-Error "Error creating DLP rule: $_"
}

# Set new values for a DLP rule
try {
    Set-DLPComplianceRule -Identity $RuleName -NotifyUser LastModifier, user@contoso.com, user2@contoso.com `
    -NotifyUserType Email -NotifyEmailCustomText $email -GenerateAlert SiteAdmin -Priority 0
} catch {
    Write-Error "Error setting DLP rule values: $_"
}

try {
    Set-DLPComplianceRule -Identity $RuleName -GenerateIncidentReport "user@contoso.com"
} catch {
    Write-Error "Error setting DLP rule incident report: $_"
}