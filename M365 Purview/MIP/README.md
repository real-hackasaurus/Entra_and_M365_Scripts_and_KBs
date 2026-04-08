# Microsoft Information Protection (MIP) Scripts

Scripts for managing Microsoft Information Protection (MIP) sensitivity labels and Azure Information Protection (AIP) service settings. These scripts cover the full MIP administration lifecycle: label management, auditing, configuration, exporting settings, and troubleshooting.

## Subfolders

### [Admin_Actions](./Admin_Actions)
Scripts for directly managing MIP labels on files and revoking AIP-protected document access.

### [Auditing](./Auditing)
Scripts for retrieving and exporting AIP admin activity logs.

### [Configuration](./Configuration)
Scripts for enabling MIP features across the Microsoft 365 tenant — including PDF labeling, SharePoint/OneDrive/Teams integration, container labels, and super user management.

### [Export Settings](./Export%20Settings)
Scripts for exporting MIP-related configurations — AIP service settings, IRM configuration, label definitions, label policies, and document tracking status.

### [Troubleshooting](./Troubleshooting)
Scripts for resolving common MIP issues — retrying label policy distribution and syncing labels between Entra ID and the Security & Compliance Center.

---

## Scripts

### Admin_Actions

| Script | Description | Parameters | Module(s) |
|--------|-------------|------------|-----------|
| [Manage-MIPLabels.ps1](./Admin_Actions/Manage-MIPLabels.ps1) | Applies or removes MIP sensitivity labels on all files within a specified directory. | `-Path`, `-Action` (`apply`/`remove`), `-LabelId` (required when applying) | AzureInformationProtection |
| [Revoke-AIPDocumentAccess.ps1](./Admin_Actions/Revoke-AIPDocumentAccess.ps1) | Revokes AIP protection access for a document identified by its content name. Optionally filters by time range and document owner. | `-ContentName`, `-IssuerName`, `-FromTime`, `-ToTime`, `-Owner` | AIPService |

> **Note:** `Manage-MIPLabels.ps1` requires the **Unified Labeling Client** to be installed on the workstation running the script, and the signed-in user must have been assigned the labels to be processed.

### Auditing

| Script | Description | Parameters | Module(s) |
|--------|-------------|------------|-----------|
| [Export-AIPAdminLogs.ps1](./Auditing/Export-AIPAdminLogs.ps1) | Retrieves AIP admin logs filtered by date range and/or text, then saves them to a file. | `-Path`, `-StartDate`, `-EndDate`, `-FilterText` | AIPService |

### Configuration

| Script | Description | Parameters | Module(s) |
|--------|-------------|------------|-----------|
| [Enable-MIPFeatures.ps1](./Configuration/Enable-MIPFeatures.ps1) | Enables a selected MIP feature based on the specified action. Available actions: `AIPServiceDocumentTracking`, `PdfEncryption`, `MIPIntegrationForSPO_OD`, `MIPForContainers`. | `-action`, `-URL` (for SPO/OD), `-UPN` (for SPO/OD and Containers) | AIPService, ExchangeOnlineManagement, Microsoft.Online.SharePoint.PowerShell, AzureADPreview |
| [Enable-PDFLabeling.ps1](./Configuration/Enable-PDFLabeling.ps1) | Enables PDF labeling and encryption by setting `EnablePdfEncryption` via IRM configuration in Exchange Online. | `-UPN` | ExchangeOnlineManagement |
| [Enable-SensitivityLabelsForSPO_OD_Teams_Groups.ps1](./Configuration/Enable-SensitivityLabelsForSPO_OD_Teams_Groups.ps1) | Runs all steps required to enable sensitivity labels for SharePoint Online, OneDrive, Teams, and M365 Groups: enables AIP integration in SPO, enables MIP labels for containers in Entra ID, and syncs labels. | `-URL`, `-UPN` | Microsoft.Online.SharePoint.PowerShell, AzureADPreview, ExchangeOnlineManagement |
| [Manage-MIPSuperUsers.ps1](./Configuration/Manage-MIPSuperUsers.ps1) | Manages AIP/MIP super users. Actions: `enable`, `disable`, `adduser`, `addgroup`, `removeuser`, `removegroup`, `listallsuperusers`, `listcurrentstate`. | `-Action`, `-User` (comma-separated), `-Group` | AIPService |

### Export Settings

| Script | Description | Parameters | Module(s) |
|--------|-------------|------------|-----------|
| [Export-AIPServiceAdminLog.ps1](./Export%20Settings/Export-AIPServiceAdminLog.ps1) | Exports the complete AIP service admin log (all PowerShell admin commands that have been run) to a file. | `-Path` | AIPService |
| [Export-MIPConfigurations.ps1](./Export%20Settings/Export-MIPConfigurations.ps1) | Exports a selected MIP configuration to a text file. Actions: `AIP Service Configuration`, `IRM Configuration`, `MIP Labels`, `MIP Label Policies`, `Document Tracking Status`. | `-Action`, `-ExportPath`, `-UPN` (required for IRM, Labels, and Policies) | AIPService, ExchangeOnlineManagement |

### Troubleshooting

| Script | Description | Parameters | Module(s) |
|--------|-------------|------------|-----------|
| [Retry-LabelPolicyDistribution.ps1](./Troubleshooting/Retry-LabelPolicyDistribution.ps1) | Retries the distribution of a specified MIP label policy in Exchange Online. Use when a label policy is stuck or not propagating to users. | `-UPN`, `-PolicyIdentity` | ExchangeOnlineManagement |
| [Sync-MIPLabels.ps1](./Troubleshooting/Sync-MIPLabels.ps1) | Triggers an Azure AD label sync to push MIP labels from Entra ID to the Security & Compliance Center. | `-UPN` | ExchangeOnlineManagement |

---

## Prerequisites

| Module | Install Command |
|--------|----------------|
| AIPService | `Install-Module -Name AIPService` |
| AzureInformationProtection | Installed with the [Unified Labeling Client](https://www.microsoft.com/en-us/download/details.aspx?id=53018) |
| ExchangeOnlineManagement | `Install-Module -Name ExchangeOnlineManagement` |
| Microsoft.Online.SharePoint.PowerShell | `Install-Module -Name Microsoft.Online.SharePoint.PowerShell` |
| AzureADPreview | `Install-Module -Name AzureADPreview` |

## Permissions

Most scripts require one or more of the following roles:
- **Azure Information Protection Administrator**
- **Global Administrator**
- **Security Administrator**
- **SharePoint Administrator**

Refer to the `.PERMISSIONS NEEDED` section in each script's comment block for the exact role requirements.
