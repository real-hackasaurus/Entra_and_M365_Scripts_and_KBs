# M365 Purview Scripts

Scripts and tools for Microsoft 365 Purview — covering Data Loss Prevention (DLP), Microsoft Information Protection (MIP), Office Message Encryption (OME), Retention Policies and Labels, and eDiscovery.

## Subfolders

### [Audit](./Audit)
SharePoint Online audit log query templates for common events (e.g., site deletion, user additions to SPO groups).

### [DLP](./DLP)
Scripts for creating and managing Data Loss Prevention policies and rules, and for troubleshooting DLP classification behavior.

### [MIP](./MIP)
Microsoft Information Protection scripts organized by use case — admin label management, auditing AIP logs, enabling MIP features, exporting MIP configurations, and troubleshooting label distribution.

### [OME](./OME)
Scripts for exporting and reviewing Office Message Encryption (OME) service configurations, RMS templates, and IRM settings.

### [Retention Labels and Policies (Retention Labels)](./Retention%20Labels%20and%20Policies%20%28Retention%20Labels%29)
Scripts for generating mailbox retention reports, checking label policy publishing status, and creating adaptive scopes for targeted retention.

### [Retention Policies (Not Labels or MRM)](./Retention%20Policies%20%28Not%20Labels%20or%20MRM%29)
Scripts for bulk-creating and updating Purview retention policies (excluding MRM and label-based retention), including Teams channel location management.

### [eDiscovery](./eDiscovery)
Scripts for managing eDiscovery case holds, generating hold reports, and searching holds by custodian or SharePoint site.

---

## Quick Reference

| Area | Script | Description |
|------|--------|-------------|
| DLP | [Manage-DLPRulesAndPolicies.ps1](./DLP/Manage-DLPRulesAndPolicies.ps1) | Creates and manages DLP policies and rules. |
| DLP | [Analyze-DLPCharacterProximity.ps1](./DLP/Troubleshooting/Analyze-DLPCharacterProximity.ps1) | Classifies text and analyzes DLP character proximity. |
| MIP | [Manage-MIPLabels.ps1](./MIP/Admin_Actions/Manage-MIPLabels.ps1) | Applies or removes MIP labels on files in a directory. |
| MIP | [Revoke-AIPDocumentAccess.ps1](./MIP/Admin_Actions/Revoke-AIPDocumentAccess.ps1) | Revokes AIP protection access on a document by name. |
| MIP | [Export-AIPAdminLogs.ps1](./MIP/Auditing/Export-AIPAdminLogs.ps1) | Exports filtered AIP admin logs to a file. |
| MIP | [Enable-MIPFeatures.ps1](./MIP/Configuration/Enable-MIPFeatures.ps1) | Enables AIP document tracking, PDF encryption, SPO/OD integration, or container labels. |
| MIP | [Enable-PDFLabeling.ps1](./MIP/Configuration/Enable-PDFLabeling.ps1) | Enables PDF labeling and encryption via IRM. |
| MIP | [Enable-SensitivityLabelsForSPO_OD_Teams_Groups.ps1](./MIP/Configuration/Enable-SensitivityLabelsForSPO_OD_Teams_Groups.ps1) | Enables sensitivity labels for SPO, OneDrive, Teams, and M365 Groups. |
| MIP | [Manage-MIPSuperUsers.ps1](./MIP/Configuration/Manage-MIPSuperUsers.ps1) | Enables/disables and manages MIP/AIP super users and super user groups. |
| MIP | [Export-AIPServiceAdminLog.ps1](./MIP/Export%20Settings/Export-AIPServiceAdminLog.ps1) | Exports the full AIP service admin log. |
| MIP | [Export-MIPConfigurations.ps1](./MIP/Export%20Settings/Export-MIPConfigurations.ps1) | Exports AIP config, IRM config, labels, label policies, and document tracking status. |
| MIP | [Retry-LabelPolicyDistribution.ps1](./MIP/Troubleshooting/Retry-LabelPolicyDistribution.ps1) | Retries distribution of a MIP label policy. |
| MIP | [Sync-MIPLabels.ps1](./MIP/Troubleshooting/Sync-MIPLabels.ps1) | Syncs MIP labels from Entra ID to the Compliance Center. |
| OME | [Export-OMEServiceConfiguration.ps1](./OME/Export-OMEServiceConfiguration.ps1) | Exports the current OME service configuration. |
| OME | [Export-RMSTemplates.ps1](./OME/Export-RMSTemplates.ps1) | Exports all RMS templates in the environment. |
| OME | [Get-IRMConfiguration.ps1](./OME/Get-IRMConfiguration.ps1) | Retrieves the active IRM configuration. |
| Retention Labels | [Generate-MailboxRetentionReport.ps1](./Retention%20Labels%20and%20Policies%20%28Retention%20Labels%29/Generate-MailboxRetentionReport.ps1) | Generates a detailed retention report for a mailbox. |
| Retention Labels | [Get-RetentionLabelPolicyPublishingStatus.ps1](./Retention%20Labels%20and%20Policies%20%28Retention%20Labels%29/Get-RetentionLabelPolicyPublishingStatus.ps1) | Retrieves the publishing status of a retention label policy. |
| Retention Labels | [New-AdaptiveScopes.ps1](./Retention%20Labels%20and%20Policies%20%28Retention%20Labels%29/New-AdaptiveScopes/New-AdaptiveScopes.ps1) | Creates adaptive scopes from a CSV file. |
| Retention Policies | [New-RetentionPolicy.ps1](./Retention%20Policies%20%28Not%20Labels%20or%20MRM%29/New-RetentionPolicy/New-RetentionPolicy.ps1) | Creates new retention policies from a CSV file. |
| Retention Policies | [New-RetentionPolicyRule.ps1](./Retention%20Policies%20%28Not%20Labels%20or%20MRM%29/New-RetentionPolicy/New-RetentionPolicyRule.ps1) | Creates retention policy rules from a CSV file. |
| Retention Policies | [Update-RetentionPolicy.ps1](./Retention%20Policies%20%28Not%20Labels%20or%20MRM%29/Update-RetentionPolicy/Update-RetentionPolicy.ps1) | Updates existing retention policies from a CSV file. |
| Retention Policies | [Update-TeamsChannelLocation.ps1](./Retention%20Policies%20%28Not%20Labels%20or%20MRM%29/Update-TeamsChannelLocation/Update-TeamsChannelLocation.ps1) | Updates Teams channel locations in retention policies from a CSV file. |
| eDiscovery | [Remove-SPOFromeDiscoveryHold.ps1](./eDiscovery/Admin_Tasks/Remove-SPOFromeDiscoveryHold.ps1) | Removes SharePoint sites from an eDiscovery hold. |
| eDiscovery | [Generate-eDiscoveryHoldsReport.ps1](./eDiscovery/Reports/Generate-eDiscoveryHoldsReport.ps1) | Generates a CSV report of eDiscovery cases and holds. |
| eDiscovery | [Search-eDiscoveryCustodianHolds.ps1](./eDiscovery/Search/Search-eDiscoveryCustodianHolds.ps1) | Searches eDiscovery holds by custodian hold ID. |
| eDiscovery | [Search-eDiscoverySPOSites.ps1](./eDiscovery/Search/Search-eDiscoverySPOSites.ps1) | Searches an eDiscovery hold for matching SPO site patterns. |

## Prerequisites

Most scripts require the **ExchangeOnlineManagement** module. MIP/AIP scripts additionally require the **AIPService** or **AzureInformationProtection** module. Refer to the `.MODULES NEEDED` section in each script's comment block for specifics.
