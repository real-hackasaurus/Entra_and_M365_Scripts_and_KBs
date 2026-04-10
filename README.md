# Entra ID and M365 Scripts and Knowledge Base
Various scripts and knowledge base articles that I have worked on throughout the years, covering Microsoft Entra ID (formerly Azure AD) and Microsoft 365 services.

## Contents of Folders

### [Entra ID](./EntraID)
- [Groups](./EntraID/Groups)
  - Scripts for managing Entra ID (Azure AD) groups — copy, export, manage, and remove group members, and configure Unified Group welcome messages.
- [Licensing](./EntraID/Licensing)
  - Scripts for generating Office 365 user license reports.
- [Users](./EntraID/Users)
  - Scripts for inviting guest users individually or in bulk via CSV.

### [Graph API](./Graph%20API)
- REST API request files for querying Microsoft Graph, including DLP alert queries via the Security API.

### [M365 Core Services](./M365%20Core%20Services)
- [Project Online](./M365%20Core%20Services/Project%20Online)
  - JavaScript plugins for the Project Online People Picker.
- [SharePoint Online](./M365%20Core%20Services/SharePoint%20Online)
  - Scripts for managing SharePoint Online site property bags, custom permission levels, and restricted access control.

### [M365 Defender](./M365%20Defender)
- [MDCA](./M365%20Defender/MDCA) — Microsoft Defender for Cloud Apps
  - [Advanced Hunting](./M365%20Defender/MDCA/Advanced%20Hunting) — KQL queries for filtering by application in MDCA.
  - [API Examples](./M365%20Defender/MDCA/API%20Examples) — Postman collection for the MDCA API.
- [MDO](./M365%20Defender/MDO) — Microsoft Defender for Office 365
  - [Advanced Hunting](./M365%20Defender/MDO/Advanced%20Hunting) — KQL queries for email alerts, undelivered emails, and Safe Link/Attachment alerts.
  - [Alerts](./M365%20Defender/MDO/Alerts) — Scripts for exporting M365 Defender activity and alert policies.
  - [Anti-Phishing](./M365%20Defender/MDO/Anti-Phishing) — Scripts for exporting anti-phishing policies and rules.
  - [Safe Links and Safe Attachments](./M365%20Defender/MDO/Safe%20Links%20and%20Safe%20Attachments) — Scripts for configuring and exporting Safe Links, Safe Attachments, and O365 threat protection policies. Includes demo files.

### [M365 Power Platform](./M365%20Power%20Platform)
- [Power BI](./M365%20Power%20Platform/Power%20BI)
  - Power Query (`.pq`) source files for connecting Power BI to Microsoft 365 Defender Advanced Hunting.

### [M365 Purview](./M365%20Purview)
- [Audit](./M365%20Purview/Audit)
  - SharePoint Online audit log query templates.
- [DLP](./M365%20Purview/DLP)
  - Scripts for creating and managing Data Loss Prevention policies and rules, testing DLP policies against files, and troubleshooting DLP character proximity.
- [MIP](./M365%20Purview/MIP)
  - Microsoft Information Protection scripts organized by category: Admin Actions, Auditing, Configuration, Export Settings, and Troubleshooting.
- [OME](./M365%20Purview/OME)
  - Scripts for exporting Office Message Encryption service configurations, RMS templates, and IRM configuration.
- [Retention](./M365%20Purview/Retention)
  - [Labels](./M365%20Purview/Retention/Labels) — Scripts for generating mailbox retention reports, checking label policy publishing status, and creating adaptive scopes.
  - [Policies](./M365%20Purview/Retention/Policies) — Scripts for creating and updating Purview retention policies and Teams channel locations via CSV.
- [eDiscovery](./M365%20Purview/eDiscovery)
  - Scripts for managing eDiscovery holds, generating hold reports, and searching holds by custodian or SharePoint site.

### [Sentinel](./Sentinel)
- Scripts and utilities for Microsoft Sentinel, including exporting Sentinel functions.

## Key Scripts

### Entra ID
| Script | Description |
|--------|-------------|
| [Copy-AADGroupMembers.ps1](./EntraID/Groups/Copy-AADGroupMembers.ps1) | Copies members from one Entra ID group to another. |
| [Export-AADGroupMembers.ps1](./EntraID/Groups/Export-AADGroupMembers.ps1) | Exports members of an Entra ID group to a CSV file. |
| [Manage-AADGroupMembers.ps1](./EntraID/Groups/Manage-AADGroupMembers.ps1) | Imports or exports members and owners of Entra ID groups via CSV. |
| [Remove-AADGroupMembers.ps1](./EntraID/Groups/Remove-AADGroupMembers.ps1) | Removes specified users from multiple Entra ID groups. |
| [Set-UnifiedGroupWelcomeMessage.ps1](./EntraID/Groups/Set-UnifiedGroupWelcomeMessage.ps1) | Enables or disables the welcome message for Office 365 Unified Groups. |
| [Generate-O365UserLicenseReport.ps1](./EntraID/Licensing/O365UserLicenseReport/Generate-O365UserLicenseReport.ps1) | Generates a detailed report of all O365 user licenses and service statuses. |
| [Invite-GuestUser.ps1](./EntraID/Users/Invite-GuestUser.ps1) | Invites a single guest user to the Entra ID environment. |
| [Bulk-InviteGuestUsers.ps1](./EntraID/Users/Bulk%20Invite%20Guest%20Users/Bulk-InviteGuestUsers.ps1) | Bulk-invites guest users from a CSV file using Microsoft Graph. |

### M365 Core Services
| Script | Description |
|--------|-------------|
| [Create-NoDeletePermissionLevel.ps1](./M365%20Core%20Services/SharePoint%20Online/Create-NoDeletePermissionLevel.ps1) | Creates a custom SPO permission level based on Full Control but without delete permissions. |
| [Enable-SPORestrictedAccessControl.ps1](./M365%20Core%20Services/SharePoint%20Online/Enable-SPORestrictedAccessControl.ps1) | Enables restricted access control for a SharePoint Online tenant. |
| [Get-SitePropertyBag.ps1](./M365%20Core%20Services/SharePoint%20Online/Add%20and%20Remove%20Site%20Property%20Bag%20Keys%20and%20Values/Get-SitePropertyBag.ps1) | Retrieves site property bag keys and values from a SharePoint Online site. |
| [Update-SitePropertyBag.ps1](./M365%20Core%20Services/SharePoint%20Online/Add%20and%20Remove%20Site%20Property%20Bag%20Keys%20and%20Values/Update-SitePropertyBag.ps1) | Adds or updates site property bag keys and values on a SharePoint Online site. |
| [Remove-SitePropertyBag.ps1](./M365%20Core%20Services/SharePoint%20Online/Add%20and%20Remove%20Site%20Property%20Bag%20Keys%20and%20Values/Remove-SitePropertyBag.ps1) | Removes site property bag keys from a SharePoint Online site. |

### M365 Defender
| Script | Description |
|--------|-------------|
| [Export-M365DefenderAlertPolicies.ps1](./M365%20Defender/MDO/Alerts/Export-M365DefenderAlertPolicies.ps1) | Exports all Activity and Alert policies from the Security Portal to CSV. |
| [Export-AntiPhishingPolicies.ps1](./M365%20Defender/MDO/Anti-Phishing/Export-AntiPhishingPolicies.ps1) | Exports all anti-phishing policies and rules to CSV files. |
| [Configure-SafeAttachmentsForSPO_OD_Teams.ps1](./M365%20Defender/MDO/Safe%20Links%20and%20Safe%20Attachments/Configure-SafeAttachmentsForSPO_OD_Teams.ps1) | Configures Safe Attachments for SharePoint Online, OneDrive, and Teams. |
| [Export-O365ThreatProtectionPolicies.ps1](./M365%20Defender/MDO/Safe%20Links%20and%20Safe%20Attachments/Export-O365ThreatProtectionPolicies.ps1) | Exports global Safe Attachments and Safe Links configurations to CSV. |
| [Export-SafeAttachmentsPolicies.ps1](./M365%20Defender/MDO/Safe%20Links%20and%20Safe%20Attachments/Export-SafeAttachmentsPolicies.ps1) | Exports all Safe Attachment policies and rules to CSV files. |
| [Export-SafeLinksPolicies.ps1](./M365%20Defender/MDO/Safe%20Links%20and%20Safe%20Attachments/Export-SafeLinksPolicies.ps1) | Exports all Safe Links policies and rules to CSV files. |

### M365 Purview — DLP
| Script | Description |
|--------|-------------|
| [Manage-DLPRulesAndPolicies.ps1](./M365%20Purview/DLP/Manage-DLPRulesAndPolicies.ps1) | Creates and manages DLP policies and rules in Exchange Online. |
| [Test-DLPPolicyAgainstFile.ps1](./M365%20Purview/DLP/Test-DLPPolicyAgainstFile.ps1) | Tests a DLP policy against a specified file. |
| [Analyze-DLPCharacterProximity.ps1](./M365%20Purview/DLP/Troubleshooting/Analyze-DLPCharacterProximity.ps1) | Extracts and classifies text from a file to analyze DLP character proximity. |

### M365 Purview — MIP
| Script | Description |
|--------|-------------|
| [Manage-MIPLabels.ps1](./M365%20Purview/MIP/Admin_Actions/Manage-MIPLabels.ps1) | Applies or removes MIP sensitivity labels on files in a directory. |
| [Revoke-AIPDocumentAccess.ps1](./M365%20Purview/MIP/Admin_Actions/Revoke-AIPDocumentAccess.ps1) | Revokes access to an AIP-protected document by content name. |
| [Export-AIPAdminLogs.ps1](./M365%20Purview/MIP/Auditing/Export-AIPAdminLogs.ps1) | Exports filtered AIP admin logs to a file based on date range and text filter. |
| [Enable-MIPFeatures.ps1](./M365%20Purview/MIP/Configuration/Enable-MIPFeatures.ps1) | Enables various MIP features: document tracking, PDF encryption, SPO/OD integration, and container labels. |
| [Enable-PDFLabeling.ps1](./M365%20Purview/MIP/Configuration/Enable-PDFLabeling.ps1) | Enables PDF labeling and encryption via Exchange Online IRM configuration. |
| [Enable-SensitivityLabelsForSPO_OD_Teams_Groups.ps1](./M365%20Purview/MIP/Configuration/Enable-SensitivityLabelsForSPO_OD_Teams_Groups.ps1) | Enables sensitivity labels for SharePoint Online, OneDrive, Teams, and M365 Groups. |
| [Manage-MIPSuperUsers.ps1](./M365%20Purview/MIP/Configuration/Manage-MIPSuperUsers.ps1) | Manages MIP/AIP super users — enable, disable, add/remove users and groups. |
| [Export-AIPServiceAdminLog.ps1](./M365%20Purview/MIP/Export%20Settings/Export-AIPServiceAdminLog.ps1) | Exports the full AIP service admin log to a file. |
| [Export-MIPConfigurations.ps1](./M365%20Purview/MIP/Export%20Settings/Export-MIPConfigurations.ps1) | Exports AIP service config, IRM config, MIP labels, label policies, and document tracking status. |
| [Retry-LabelPolicyDistribution.ps1](./M365%20Purview/MIP/Troubleshooting/Retry-LabelPolicyDistribution.ps1) | Retries the distribution of a MIP label policy in Exchange Online. |
| [Sync-MIPLabels.ps1](./M365%20Purview/MIP/Troubleshooting/Sync-MIPLabels.ps1) | Syncs MIP labels from Entra ID to the Security & Compliance Center. |

### M365 Purview — OME
| Script | Description |
|--------|-------------|
| [Export-OMEServiceConfiguration.ps1](./M365%20Purview/OME/Export-OMEServiceConfiguration.ps1) | Exports the current Office Message Encryption service configuration. |
| [Export-RMSTemplates.ps1](./M365%20Purview/OME/Export-RMSTemplates.ps1) | Exports all RMS templates in the environment. |
| [Get-IRMConfiguration.ps1](./M365%20Purview/OME/Get-IRMConfiguration.ps1) | Retrieves the active IRM configuration, useful for troubleshooting MIP. |

### M365 Purview — Retention
| Script | Description |
|--------|-------------|
| [Generate-MailboxRetentionReport.ps1](./M365%20Purview/Retention/Labels/Generate-MailboxRetentionReport.ps1) | Generates a detailed retention report for a specified mailbox. |
| [Get-RetentionLabelPolicyPublishingStatus.ps1](./M365%20Purview/Retention/Labels/Get-RetentionLabelPolicyPublishingStatus.ps1) | Retrieves the publishing status of a retention label policy. |
| [New-AdaptiveScopes.ps1](./M365%20Purview/Retention/Labels/New-AdaptiveScopes/New-AdaptiveScopes.ps1) | Creates new Purview adaptive scopes from a CSV file. |
| [New-RetentionPolicy.ps1](./M365%20Purview/Retention/Policies/New-RetentionPolicy/New-RetentionPolicy.ps1) | Creates new retention policies in Purview from a CSV file. |
| [New-RetentionPolicyRule.ps1](./M365%20Purview/Retention/Policies/New-RetentionPolicy/New-RetentionPolicyRule.ps1) | Creates retention policy rules from a CSV file. |
| [Update-RetentionPolicy.ps1](./M365%20Purview/Retention/Policies/Update-RetentionPolicy/Update-RetentionPolicy.ps1) | Updates existing retention policies in Purview from a CSV file. |
| [Update-TeamsChannelLocation.ps1](./M365%20Purview/Retention/Policies/Update-TeamsChannelLocation/Update-TeamsChannelLocation.ps1) | Updates Teams channel locations in retention policies from a CSV file. |

### M365 Purview — eDiscovery
| Script | Description |
|--------|-------------|
| [Remove-SPOFromeDiscoveryHold.ps1](./M365%20Purview/eDiscovery/Admin_Tasks/Remove-SPOFromeDiscoveryHold.ps1) | Removes specified SharePoint sites from an eDiscovery hold. |
| [Generate-eDiscoveryHoldsReport.ps1](./M365%20Purview/eDiscovery/Reports/Generate-eDiscoveryHoldsReport.ps1) | Generates a CSV report of all eDiscovery cases and holds. |
| [Search-eDiscoveryCustodianHolds.ps1](./M365%20Purview/eDiscovery/Search/Search-eDiscoveryCustodianHolds.ps1) | Searches eDiscovery holds by custodian hold ID and outputs SharePoint locations. |
| [Search-eDiscoverySPOSites.ps1](./M365%20Purview/eDiscovery/Search/Search-eDiscoverySPOSites.ps1) | Searches an eDiscovery hold for matching SharePoint site patterns. |