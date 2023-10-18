<#
.SYNOPSIS
    Modifies the welcome message setting for specified Office 365 Unified Groups.

.DESCRIPTION
    This script connects to Office 365 and enables or disables the welcome message for the specified Unified Groups 
    based on the provided parameter. This can be useful in scenarios where you want to control the welcome emails 
    for new members of a group.

.PARAMETER Groups
    The names of the Unified Groups for which the welcome message setting should be modified, separated by commas.

.PARAMETER EnableWelcomeMessage
    Switch parameter. If provided, the script will enable the welcome message for the groups. 
    If not provided, it will disable the welcome message.

.EXAMPLE
    .\ModifyUnifiedGroupWelcomeMessage.ps1 -Groups "Group1, Group2" -EnableWelcomeMessage

    Enables the welcome message for the Unified Groups named "Group1" and "Group2".

.EXAMPLE
    .\ModifyUnifiedGroupWelcomeMessage.ps1 -Groups "Group1, Group2"

    Disables the welcome message for the Unified Groups named "Group1" and "Group2".

.EXAMPLE
    .\ModifyUnifiedGroupWelcomeMessage.ps1 -Groups "Group3" -EnableWelcomeMessage

    Enables the welcome message for the Unified Group named "Group3".

.EXAMPLE
    .\ModifyUnifiedGroupWelcomeMessage.ps1 -Groups "Group4"

    Disables the welcome message for the Unified Group named "Group4".

.NOTES
    File Name      : ModifyUnifiedGroupWelcomeMessage.ps1
    Author         : Wes Blackwell
    Prerequisite   : ExchangeOnlineManagement Module

#>

param (
    [Parameter(Mandatory=$true)]
    [string]$Groups,
    
    [Parameter(Mandatory=$false)]
    [switch]$EnableWelcomeMessage
)

# Import required module (You can uncomment this if needed)
# Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline

# Split and trim the group names
$GroupArray = $Groups -split ',' | ForEach-Object { $_.Trim() }

# Modify Unified Group Welcome Message Setting based on the switch
$GroupArray | ForEach-Object {
    Set-UnifiedGroup -Identity $_ -UnifiedGroupWelcomeMessageEnabled:$EnableWelcomeMessage.IsPresent
}