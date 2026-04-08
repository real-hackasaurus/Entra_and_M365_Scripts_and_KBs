# Entra ID Scripts

Scripts for managing Microsoft Entra ID (formerly Azure Active Directory) — groups, licensing, and user/guest management.

## Subfolders

### [Groups](./Groups)
Scripts for creating, copying, exporting, and managing Entra ID group memberships and settings.

### [Licensing](./Licensing)
Scripts for generating detailed license reports for Office 365 users.

### [Users](./Users)
Scripts for inviting guest users to the Entra ID tenant, individually or in bulk.

---

## Scripts

### Groups

| Script | Description | Module(s) |
|--------|-------------|-----------|
| [Copy-AADGroupMembers.ps1](./Groups/Copy-AADGroupMembers.ps1) | Copies all user members from a source Entra ID group to a target group. | AzureAD / AzureADPreview |
| [Export-AADGroupMembers.ps1](./Groups/Export-AADGroupMembers.ps1) | Exports all user members of a specified Entra ID group to a CSV file. | AzureAD |
| [Manage-AADGroupMembers.ps1](./Groups/Manage-AADGroupMembers.ps1) | Imports members/owners into groups from CSV files, or exports them. Supports members and owners of multiple groups. | AzureAD |
| [Remove-AADGroupMembers.ps1](./Groups/Remove-AADGroupMembers.ps1) | Removes specified users from one or more Entra ID groups (comma-separated input). | AzureAD |
| [Set-UnifiedGroupWelcomeMessage.ps1](./Groups/Set-UnifiedGroupWelcomeMessage.ps1) | Enables or disables the welcome email message for specified Office 365 Unified Groups. | ExchangeOnlineManagement |

### Licensing

| Script | Description | Module(s) |
|--------|-------------|-----------|
| [Generate-O365UserLicenseReport.ps1](./Licensing/O365UserLicenseReport/Generate-O365UserLicenseReport.ps1) | Generates detailed and summary CSV reports of all O365 user licenses and service statuses. Optionally filtered to a list of users via CSV. | MSOnline |

Supporting files:
- `LicenseFriendlyName.txt` — Maps license SKU IDs to friendly display names.
- `ServiceFriendlyName.txt` — Maps service plan IDs to friendly display names.

### Users

| Script | Description | Module(s) |
|--------|-------------|-----------|
| [Invite-GuestUser.ps1](./Users/Invite-GuestUser.ps1) | Invites a single guest user to the Entra ID tenant with a specified display name, email, redirect URL, and optional invite email. | AzureAD |
| [Bulk-InviteGuestUsers.ps1](./Users/Bulk%20Invite%20Guest%20Users/Bulk-InviteGuestUsers.ps1) | Bulk-invites guest users by reading user details from a CSV file. | Microsoft.Graph |

Supporting files:
- `Bulk_User_Template.csv` — CSV template for bulk guest user invitations.

## Prerequisites

- **AzureAD / AzureADPreview** — `Install-Module AzureAD` or `Install-Module AzureADPreview`
- **MSOnline** — `Install-Module MSOnline`
- **Microsoft.Graph** — `Install-Module Microsoft.Graph`
- **ExchangeOnlineManagement** — `Install-Module ExchangeOnlineManagement`

Ensure you have connected to the appropriate service before running each script (e.g., `Connect-AzureAD`, `Connect-MsolService`, `Connect-MgGraph`, `Connect-ExchangeOnline`).
