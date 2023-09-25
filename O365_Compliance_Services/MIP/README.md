<h1>Troubleshooting Scripts</h1>
<h3>1. Export_Labels.ps1</h3>
&emsp;• Pull down all labels and label policies in an enviornment and export it to a txt file.<br>
<h3>2. Export_IRM_configuration.ps1</h3>
&emsp;• Display what the active IRM settings are. This can be useful in troubleshooting MIP.<br>
<h3>3. Retry_Policy_Distribution.ps1</h3>
&emsp;• Retry policy distribution if the distribution status may be hung up (i.e. pending).<br>
<h3>4. Export_AIP_Service_Admin_Log.ps1</h3>
&emsp;• Export any admin commands that have been ran, including PowerShell commands.<br>
<h3>5. Export_AIP_Service_Information.ps1</h3>
&emsp;• Export the AIP service information such as if it is on, what platforms is it turned on for, etc...<br>
<br>
<br>
<h1>Additional Tools</h1>
<h3>1. Unified Labeling Support Tool: https://github.com/microsoft/UnifiedLabelingSupportTool</h3>
    &emsp;• The 'Unified Labeling Support Tool' provides the functionality to reset all corresponding client services (UL, AIP, MIP, etc.). Its main purpose is to delete the currently downloaded sensitivity label policies and thus reset all settings, and it can also be used to collect data for failure analysis and problem solving.<br>
<br>
<br>
<h1>Other Tips</h1>
<h3>1. Labels do not work at all</h3>
    &emsp;• If labels do not work in your environment at all, there could be a severe issue. I have noticed this issue along with other issues such as Safe Links breaking as well. A potential fix for this is a full tenant sync. This is not a procedure that regular org admins can make. This procedure is performed by Microsoft customer support.<br>
<h1>MSFT TroubleShooting Docs</h1>
    &emsp;• <a href="https://support.microsoft.com/en-us/office/known-issues-with-sensitivity-labels-in-office-b169d687-2bbd-4e21-a440-7da1b2743edc#ID0EDD=Office_365">Known issues with sensitivity labels in Office.</a><br>
    &emsp;• <a href="https://docs.microsoft.com/en-us/troubleshoot/azure/general/troubleshoot-aip-issues">How to troubleshoot Azure Information Protection policy issues</a><br>
