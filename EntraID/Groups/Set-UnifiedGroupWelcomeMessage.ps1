<#
.SYNOPSIS
Modifies the welcome message setting for specified Office 365 Unified Groups.

.DESCRIPTION
This script connects to Office 365 and enables or disables the welcome message for the specified Unified Groups 
based on the provided parameter. This can be useful in scenarios where you want to control the welcome emails 
for new members of a group.

.INSTRUCTIONS
1. Ensure you have the ExchangeOnlineManagement module installed.
2. Connect to your Office 365 using the Connect-ExchangeOnline cmdlet.
3. Run the script with the required parameters or set the environment variables.

.PERMISSIONS
You need to have sufficient permissions to modify the welcome message settings for the specified groups in Office 365.

.MODULES NEEDED
- ExchangeOnlineManagement

.PARAMETER Groups
The names of the Unified Groups for which the welcome message setting should be modified, separated by commas.

.PARAMETER EnableWelcomeMessage
Switch parameter. If provided, the script will enable the welcome message for the groups. 
If not provided, it will disable the welcome message.

.EXAMPLE
.\Set-UnifiedGroupWelcomeMessage.ps1 -Groups "Group1, Group2" -EnableWelcomeMessage

Enables the welcome message for the Unified Groups named "Group1" and "Group2".

.EXAMPLE
.\Set-UnifiedGroupWelcomeMessage.ps1 -Groups "Group1, Group2"

Disables the welcome message for the Unified Groups named "Group1" and "Group2".

.EXAMPLE
.\Set-UnifiedGroupWelcomeMessage.ps1 -Groups "Group3" -EnableWelcomeMessage

Enables the welcome message for the Unified Group named "Group3".

.EXAMPLE
.\Set-UnifiedGroupWelcomeMessage.ps1 -Groups "Group4"

Disables the welcome message for the Unified Group named "Group4".

.NOTES
File Name      : Set-UnifiedGroupWelcomeMessage.ps1
Author         : Wes Blackwell
Prerequisite   : ExchangeOnlineManagement Module
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$Groups = $env:GROUPS,
    
    [Parameter(Mandatory=$false)]
    [switch]$EnableWelcomeMessage = [switch]::new($env:ENABLE_WELCOME_MESSAGE)
)

# Ensure parameters are not empty
if (-not $Groups) {
    Write-Error "Groups parameter is empty or not set!"
    exit
}

# Import required module (You can uncomment this if needed)
# Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
try {
    Connect-ExchangeOnline
} catch {
    Write-Error "Failed to connect to Exchange Online: $_"
    exit
}

# Split and trim the group names
$GroupArray = $Groups -split ',' | ForEach-Object { $_.Trim() }

# Modify Unified Group Welcome Message Setting based on the switch
$GroupArray | ForEach-Object {
    try {
        Set-UnifiedGroup -Identity $_ -UnifiedGroupWelcomeMessageEnabled:$EnableWelcomeMessage.IsPresent
    } catch {
        Write-Error "Failed to modify welcome message setting for group '$_'. Error: $_"
    }
}