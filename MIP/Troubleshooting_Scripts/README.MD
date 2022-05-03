<h1>Troubleshooting Scripts</h1>
<h3>1. Export_Labels.ps1</h3>
&emsp;• Pull down all labels and label policies in an enviornment and export it to a txt file.<br>
<h3>2. Export_IRM_configuration.ps1</h3>
&emsp;• Display what the active IRM settings are. This can be useful in troubleshooting MIP.<br>
<h3>3. Retry_Policy_Distribution.ps1</h3>
&emsp;• Retry policy distribution if the distribution status may be hung up (i.e. pending).<br>
<br>
<br>
<h1>Additional Tools</h1>
<h3>1. Unified Labeling Support Tool: https://github.com/microsoft/UnifiedLabelingSupportTool</h3>
    &emsp;• The 'Unified Labeling Support Tool' provides the functionality to reset all corresponding client services (UL, AIP, MIP, etc.). Its main purpose is to delete the currently downloaded sensitivity label policies and thus reset all settings, and it can also be used to collect data for failure analysis and problem solving.<br>