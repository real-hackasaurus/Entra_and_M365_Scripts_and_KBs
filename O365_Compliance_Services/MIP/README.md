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

<h1>Best Practices for Microsoft Information Protection</h1>
<h2>Phase 1</h2>
&emsp;• Acquire licensing for service, preferably in the E5 suite. This suite contains all the advanced features.</br>
&emsp;• Enable several configurations, listed below:</br>
&emsp;&emsp;• <a href="https://github.com/Leafry/AzureAndO365Scripts/blob/main/O365_Compliance_Portal_Services/MIP/Configuration/Enabel_Labels_PDFs.ps1">Enable support for PDFs</a></br>
&emsp;&emsp;• <a href="https://github.com/Leafry/AzureAndO365Scripts/blob/main/O365_Compliance_Portal_Services/MIP/Configuration/Enable_Labels_SPO_Sites_Teams_M365_Groups.ps1">Enable support in SPO, OD, Teams, and M365 groups.</a></br>
&emsp;• Create a set of "global" labels to act as a baseline for all users.</br>
&emsp;• Deploy the Unified Labeling Client, but disable the add-in for all users. *this step is needed for as long as the client is in maintenance mode</br>
&emsp;&emsp;• <a href="https://docs.microsoft.com/en-us/microsoft-365/compliance/sensitivity-labels-aip?view=o365-worldwide#how-to-disable-the-aip-add-in-to-use-built-in-labeling-for-office-apps">How to disable the AIP add-in to use built-in labeling for Office apps</a><br>

<h2>Phase 2</h2>
&emsp;• Test labels with a pilot group. Add and update labels as needed.</br>

<h2>Phase 3</h2>
&emsp;• After all pilot testing is complete, deploy the policy org wide.</br>