# M365 Defender Scripts

Scripts and KQL queries for Microsoft 365 Defender — covering advanced hunting, alert policy management, anti-phishing, Microsoft Defender for Cloud Apps (MDCA), and Safe Links and Safe Attachments.

## Subfolders

### [Advanced Hunting](./Advanced%20Hunting)
KQL queries for use in the Microsoft 365 Defender Advanced Hunting portal, organized by data table/service.

### [Alerts](./Alerts)
Scripts for exporting M365 Defender activity and alert policies.

### [Anti-Phishing](./Anti-Phishing)
Scripts for exporting anti-phishing policies and rules.

### [MDCA](./MDCA)
Microsoft Defender for Cloud Apps API examples, including a Postman collection for common API calls.

### [Safe Links and Safe Attachments](./Safe%20Links%20and%20Safe%20Attachments)
Scripts for configuring and exporting Safe Links, Safe Attachments, and global O365 threat protection policies. Includes demo files for testing Safe Links and Safe Documents.

---

## Scripts

### Advanced Hunting (KQL Queries)

| Query File | Table | Description |
|------------|-------|-------------|
| [FilterByApplication.kql](./Advanced%20Hunting/CloudAppEvents%28MDCA%29/FilterByApplication.kql) | CloudAppEvents | Filters cloud app events by a specific application name. |
| [FindEmailAlertByRecipient.kql](./Advanced%20Hunting/Defender_for_Office%28MDO%29/FindEmailAlertByRecipient.kql) | EmailEvents / AlertEvidence | Finds email-related alerts filtered by recipient address. |
| [FindUndeliveredEmails.kql](./Advanced%20Hunting/Defender_for_Office%28MDO%29/FindUndeliveredEmails.kql) | EmailEvents | Finds undelivered email messages. |
| [SafeLinkAndAttachmentAlerts.kql](./Advanced%20Hunting/Defender_for_Office%28MDO%29/SafeLinkAndAttachmentAlerts.kql) | AlertEvidence / AlertInfo | Retrieves alerts triggered by Safe Links and Safe Attachments detections. |

### Alerts

| Script | Description | Parameters | Module(s) |
|--------|-------------|------------|-----------|
| [Export-M365DefenderAlertPolicies.ps1](./Alerts/Export-M365DefenderAlertPolicies.ps1) | Exports all activity alerts and protection alert policies from the Security Portal to separate CSV files. | `-AdminUserPrincipalName`, `-ActivityAlertPath`, `-ProtectionAlertPath` | ExchangeOnlineManagement |

### Anti-Phishing

| Script | Description | Parameters | Module(s) |
|--------|-------------|------------|-----------|
| [Export-AntiPhishingPolicies.ps1](./Anti-Phishing/Export-AntiPhishingPolicies.ps1) | Exports all anti-phishing policies and rules to separate CSV files. | `-AdminUserPrincipalName`, `-AntiPhishPolicyPath`, `-AntiPhishRulePath` | ExchangeOnlineManagement |

### Safe Links and Safe Attachments

| Script | Description | Parameters | Module(s) |
|--------|-------------|------------|-----------|
| [Configure-SafeAttachmentsForSPO_OD_Teams.ps1](./Safe%20Links%20and%20Safe%20Attachments/Configure-SafeAttachmentsForSPO_OD_Teams.ps1) | Enables Safe Attachments for SharePoint Online, OneDrive, and Teams; blocks malicious file downloads; creates an alert policy; and verifies settings. | `-AdminUserPrincipalName`, `-SPOAdminUrl`, `-NotifyUsers` | ExchangeOnlineManagement |
| [Export-O365ThreatProtectionPolicies.ps1](./Safe%20Links%20and%20Safe%20Attachments/Export-O365ThreatProtectionPolicies.ps1) | Exports the global ATP policy for Office 365 (Safe Attachments and Safe Links global settings) to a CSV file. | `-AdminUserPrincipalName`, `-OutputPath` | ExchangeOnlineManagement |
| [Export-SafeAttachmentsPolicies.ps1](./Safe%20Links%20and%20Safe%20Attachments/Export-SafeAttachmentsPolicies.ps1) | Exports all Safe Attachment policies and rules to separate CSV files. | `-AdminUserPrincipalName`, `-SafeAttachmentPolicyPath`, `-SafeAttachmentRulePath` | ExchangeOnlineManagement |
| [Export-SafeLinksPolicies.ps1](./Safe%20Links%20and%20Safe%20Attachments/Export-SafeLinksPolicies.ps1) | Exports all Safe Links policies and rules to separate CSV files. | `-AdminUserPrincipalName`, `-SafeLinksPolicyPath`, `-SafeLinksRulePath` | ExchangeOnlineManagement |

### Demo Files

The `Safe Links and Safe Attachments/Demo Files` folder contains sample files for demonstrating and testing Microsoft 365 Defender features:
- **Safe_Attachments_Demo/** — A ZIP file that can be used to trigger Safe Attachments scanning.
- **Safe_Docs_Demo_Files/** — Office documents (`.docx`, `.pptx`, `.xlsx`) for testing Safe Documents protection.
- **Safe_Links_Demo/** — A text file with a test URL for Safe Links evaluation.

---

## Prerequisites

All scripts in this folder require the **ExchangeOnlineManagement** module:

```powershell
Install-Module -Name ExchangeOnlineManagement
```

## Permissions

Scripts generally require **Global Administrator** or **Security Administrator** roles. Refer to the `.PERMISSIONS` section in each script's comment block for exact requirements.
