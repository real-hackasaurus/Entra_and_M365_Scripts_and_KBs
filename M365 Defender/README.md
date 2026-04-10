# M365 Defender Scripts

Scripts and KQL queries for Microsoft 365 Defender, organized by the Defender product they belong to.

## Subfolders

### [MDO](./MDO) — Microsoft Defender for Office 365
Scripts and KQL queries for Microsoft Defender for Office 365, covering alert policies, anti-phishing, Safe Links, and Safe Attachments.

- **[Advanced Hunting](./MDO/Advanced%20Hunting)** — KQL queries for email and threat protection events in the Advanced Hunting portal.
- **[Alerts](./MDO/Alerts)** — Scripts for exporting M365 Defender activity and alert policies.
- **[Anti-Phishing](./MDO/Anti-Phishing)** — Scripts for exporting anti-phishing policies and rules.
- **[Safe Links and Safe Attachments](./MDO/Safe%20Links%20and%20Safe%20Attachments)** — Scripts for configuring and exporting Safe Links, Safe Attachments, and global O365 threat protection policies. Includes demo files for testing Safe Links and Safe Documents.

### [MDCA](./MDCA) — Microsoft Defender for Cloud Apps
Scripts, KQL queries, and API examples for Microsoft Defender for Cloud Apps.

- **[Advanced Hunting](./MDCA/Advanced%20Hunting)** — KQL queries for cloud app events in the Advanced Hunting portal.
- **[API Examples](./MDCA/API%20Examples)** — Postman collection for common MDCA API calls.

### [MDI](./MDI) — Microsoft Defender for Identity
KQL queries for Defender for Identity, covering identity-based threat detection, Active Directory monitoring, and lateral movement.

- **[Advanced Hunting](./MDI/Advanced%20Hunting)** — KQL queries for identity events, directory changes, and logon activities in the Advanced Hunting portal.

### [Defender XDR](./Defender%20XDR) — Microsoft Defender XDR
KQL queries for cross-product Defender XDR auditing and security operations monitoring.

- **[Advanced Hunting](./Defender%20XDR/Advanced%20Hunting)** — KQL queries for auditing Defender XDR configuration changes, RBAC, and incident response actions.

---

## MDO — Microsoft Defender for Office 365

### Advanced Hunting (KQL Queries)

| Query File | Table | Description |
|------------|-------|-------------|
| [FindEmailAlertByRecipient.kql](./MDO/Advanced%20Hunting/FindEmailAlertByRecipient.kql) | EmailEvents | Finds email events filtered by recipient address. |
| [FindUndeliveredEmails.kql](./MDO/Advanced%20Hunting/FindUndeliveredEmails.kql) | EmailEvents | Finds undelivered email messages. |
| [SafeLinkAndAttachmentAlerts.kql](./MDO/Advanced%20Hunting/SafeLinkAndAttachmentAlerts.kql) | UrlClickEvents / EmailEvents | Retrieves Safe Links click-through events and blocked/malware emails. |
| [ExecutableAttachmentReceived.kql](./MDO/Advanced%20Hunting/ExecutableAttachmentReceived.kql) | EmailEvents / EmailAttachmentInfo | Detects inbound emails with executable file attachments. |
| [ISOAttachmentReceived.kql](./MDO/Advanced%20Hunting/ISOAttachmentReceived.kql) | EmailEvents / EmailAttachmentInfo | Detects inbound emails with ISO disk image attachments. |
| [PotentialPhishingCampaign.kql](./MDO/Advanced%20Hunting/PotentialPhishingCampaign.kql) | EmailEvents / EmailUrlInfo | Identifies potential phishing campaigns via EmailClusterId analysis. |
| [TyposquattedEmailReceived.kql](./MDO/Advanced%20Hunting/TyposquattedEmailReceived.kql) | EmailEvents | Detects inbound emails from typosquatted domains using Jaccard similarity. |
| [MacroAttachmentFromRareSender.kql](./MDO/Advanced%20Hunting/MacroAttachmentFromRareSender.kql) | EmailAttachmentInfo / DeviceFileEvents / EmailEvents | Detects macro-enabled attachments received and opened from rare senders. |
| [SafeLinksBlockedClicks.kql](./MDO/Advanced%20Hunting/SafeLinksBlockedClicks.kql) | UrlClickEvents / EmailEvents | Lists emails where a Safe Links URL block was triggered by a user click. |
| [RareFileExtensionsReceived.kql](./MDO/Advanced%20Hunting/RareFileExtensionsReceived.kql) | EmailEvents / EmailAttachmentInfo | Lists the 20 rarest file extensions received as email attachments. |
| [PostDeliveryEvents.kql](./MDO/Advanced%20Hunting/PostDeliveryEvents.kql) | EmailPostDeliveryEvents | Summarizes post-delivery email actions (ZAP, remediation) by day. |

### Alerts

| Script | Description | Parameters | Module(s) |
|--------|-------------|------------|-----------|
| [Export-M365DefenderAlertPolicies.ps1](./MDO/Alerts/Export-M365DefenderAlertPolicies.ps1) | Exports all activity alerts and protection alert policies from the Security Portal to separate CSV files. | `-AdminUserPrincipalName`, `-ActivityAlertPath`, `-ProtectionAlertPath` | ExchangeOnlineManagement |

### Anti-Phishing

| Script | Description | Parameters | Module(s) |
|--------|-------------|------------|-----------|
| [Export-AntiPhishingPolicies.ps1](./MDO/Anti-Phishing/Export-AntiPhishingPolicies.ps1) | Exports all anti-phishing policies and rules to separate CSV files. | `-AdminUserPrincipalName`, `-AntiPhishPolicyPath`, `-AntiPhishRulePath` | ExchangeOnlineManagement |

### Safe Links and Safe Attachments

| Script | Description | Parameters | Module(s) |
|--------|-------------|------------|-----------|
| [Configure-SafeAttachmentsForSPO_OD_Teams.ps1](./MDO/Safe%20Links%20and%20Safe%20Attachments/Configure-SafeAttachmentsForSPO_OD_Teams.ps1) | Enables Safe Attachments for SharePoint Online, OneDrive, and Teams; blocks malicious file downloads; creates an alert policy; and verifies settings. | `-AdminUserPrincipalName`, `-SPOAdminUrl`, `-NotifyUsers` | ExchangeOnlineManagement |
| [Export-O365ThreatProtectionPolicies.ps1](./MDO/Safe%20Links%20and%20Safe%20Attachments/Export-O365ThreatProtectionPolicies.ps1) | Exports the global ATP policy for Office 365 (Safe Attachments and Safe Links global settings) to a CSV file. | `-AdminUserPrincipalName`, `-OutputPath` | ExchangeOnlineManagement |
| [Export-SafeAttachmentsPolicies.ps1](./MDO/Safe%20Links%20and%20Safe%20Attachments/Export-SafeAttachmentsPolicies.ps1) | Exports all Safe Attachment policies and rules to separate CSV files. | `-AdminUserPrincipalName`, `-SafeAttachmentPolicyPath`, `-SafeAttachmentRulePath` | ExchangeOnlineManagement |
| [Export-SafeLinksPolicies.ps1](./MDO/Safe%20Links%20and%20Safe%20Attachments/Export-SafeLinksPolicies.ps1) | Exports all Safe Links policies and rules to separate CSV files. | `-AdminUserPrincipalName`, `-SafeLinksPolicyPath`, `-SafeLinksRulePath` | ExchangeOnlineManagement |

### Demo Files

The `MDO/Safe Links and Safe Attachments/Demo Files` folder contains sample files for demonstrating and testing Microsoft 365 Defender features:
- **Safe_Attachments_Demo/** — A ZIP file that can be used to trigger Safe Attachments scanning.
- **Safe_Docs_Demo_Files/** — Office documents (`.docx`, `.pptx`, `.xlsx`) for testing Safe Documents protection.
- **Safe_Links_Demo/** — A text file with a test URL for Safe Links evaluation.

---

## MDCA — Microsoft Defender for Cloud Apps

### Advanced Hunting (KQL Queries)

| Query File | Table | Description |
|------------|-------|-------------|
| [FilterByApplication.kql](./MDCA/Advanced%20Hunting/FilterByApplication.kql) | CloudAppEvents | Filters cloud app events by a specific application name. |
| [AnonymousProxyEvents.kql](./MDCA/Advanced%20Hunting/AnonymousProxyEvents.kql) | CloudAppEvents | Identifies activities performed while connected through an anonymous proxy. |
| [ImpersonatedActions.kql](./MDCA/Advanced%20Hunting/ImpersonatedActions.kql) | CloudAppEvents | Lists the top 100 accounts with the most impersonated actions. |
| [SuppressionRuleCreations.kql](./MDCA/Advanced%20Hunting/SuppressionRuleCreations.kql) | CloudAppEvents | Lists alert suppression rule creations. |
| [MaliciousEmailDeliveredInMailbox.kql](./MDCA/Advanced%20Hunting/MaliciousEmailDeliveredInMailbox.kql) | CloudAppEvents | Detects malicious email delivery events logged by Defender for Cloud Apps. |

### API Examples

The `MDCA/API Examples` folder contains a Postman collection for common Microsoft Defender for Cloud Apps API calls.

---

## MDI — Microsoft Defender for Identity

### Advanced Hunting (KQL Queries)

| Query File | Table | Description |
|------------|-------|-------------|
| [UserAddedToSensitiveGroup.kql](./MDI/Advanced%20Hunting/UserAddedToSensitiveGroup.kql) | IdentityDirectoryEvents | Detects when a user is added to sensitive AD groups (Domain Admins, Enterprise Admins, etc.). |
| [PasswordChangeAfterBruteForce.kql](./MDI/Advanced%20Hunting/PasswordChangeAfterBruteForce.kql) | IdentityLogonEvents / IdentityDirectoryEvents | Detects password changes following a successful brute force attack. |
| [KerberosEncryptionDowngrade.kql](./MDI/Advanced%20Hunting/KerberosEncryptionDowngrade.kql) | IdentityDirectoryEvents | Detects changes to Kerberos encryption types that may indicate a downgrade attack. |
| [AnomalousLDAPTraffic.kql](./MDI/Advanced%20Hunting/AnomalousLDAPTraffic.kql) | IdentityQueryEvents | Identifies accounts generating anomalously high volumes of LDAP queries. |

---

## Defender XDR — Microsoft Defender XDR

### Advanced Hunting (KQL Queries)

| Query File | Table | Description |
|------------|-------|-------------|
| [CustomDetectionDisabled.kql](./Defender%20XDR/Advanced%20Hunting/CustomDetectionDisabled.kql) | CloudAppEvents | Detects when a custom detection rule is disabled in Defender XDR. |
| [RBACChanges.kql](./Defender%20XDR/Advanced%20Hunting/RBACChanges.kql) | CloudAppEvents | Audits RBAC role additions, deletions, and modifications in Defender XDR. |
| [AlertSuppressionAdded.kql](./Defender%20XDR/Advanced%20Hunting/AlertSuppressionAdded.kql) | CloudAppEvents | Lists alert suppression rules added to Defender XDR. |
| [DeviceIsolationEvents.kql](./Defender%20XDR/Advanced%20Hunting/DeviceIsolationEvents.kql) | CloudAppEvents | Detects device isolation and unisolation actions in Defender XDR. |

---

## Prerequisites

All scripts in this folder require the **ExchangeOnlineManagement** module:

```powershell
Install-Module -Name ExchangeOnlineManagement
```

## Permissions

Scripts generally require **Global Administrator** or **Security Administrator** roles. Refer to the `.PERMISSIONS` section in each script's comment block for exact requirements.
