<h1>Best Practices for Microsoft Information Protection</h1>
<h2>Phase 1</h2>
&emsp;• Acquire licensing for service, preferably in the E5 suite. This suite contains all the advanced features.</br>
&emsp;• Enable several configurations, listed below:</br>
&emsp;&emsp;• <a href="https://github.com/Leafry/AzureAndO365Scripts/blob/main/O365_Compliance_Portal_Services/MIP/Configuration/Enabel_Labels_PDFs.ps1">Enable support for PDFs</a></br>
&emsp;&emsp;• <a href="https://github.com/Leafry/AzureAndO365Scripts/blob/main/O365_Compliance_Portal_Services/MIP/Configuration/Enable_Labels_SPO_Sites_Teams_M365_Groups.ps1">Enable support for PDFs</a></br>
&emsp;• Create a set of "global" labels to act as a baseline for all users.</br>
&emsp;• Deploy the Unified Labeling Client, but disable the add-in for all users. *this step is needed for as long as the client is in maintence mode</br>
&emsp;&emsp;• <a href="https://docs.microsoft.com/en-us/microsoft-365/compliance/sensitivity-labels-aip?view=o365-worldwide#how-to-disable-the-aip-add-in-to-use-built-in-labeling-for-office-apps">How to disable the AIP add-in to use built-in labeling for Office apps</a><br>

<h2>Phase 2</h2>
&emsp;• Test labels with a pilot group. Add and update labels as needed.</br>