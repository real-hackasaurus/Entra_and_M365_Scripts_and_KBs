# M365 Core Services Scripts

Scripts and plugins for Microsoft 365 core services — SharePoint Online and Project Online.

## Subfolders

### [Project Online](./Project%20Online)
JavaScript plugins for adding a people picker control to Project Online Project Detail Pages (PDPs) and list views.

### [SharePoint Online](./SharePoint%20Online)
PowerShell scripts for managing SharePoint Online site settings, property bags, and permission levels.

---

## Scripts

### SharePoint Online

| Script | Description | Parameters | Module(s) |
|--------|-------------|------------|-----------|
| [Create-NoDeletePermissionLevel.ps1](./SharePoint%20Online/Create-NoDeletePermissionLevel.ps1) | Creates a custom SharePoint permission level cloned from Full Control but with delete permissions removed. Assigns the new level to the site owners group. | `-SiteURL` | PnP.PowerShell |
| [Enable-SPORestrictedAccessControl.ps1](./SharePoint%20Online/Enable-SPORestrictedAccessControl.ps1) | Enables the Restricted Access Control feature for a SharePoint Online tenant via the SPO admin site. | `-AdminSiteURL` | Microsoft.Online.SharePoint.PowerShell |

#### Site Property Bag (`Add and Remove Site Property Bag Keys and Values`)

| Script | Description | Parameters | Module(s) |
|--------|-------------|------------|-----------|
| [Get-SitePropertyBag.ps1](./SharePoint%20Online/Add%20and%20Remove%20Site%20Property%20Bag%20Keys%20and%20Values/Get-SitePropertyBag.ps1) | Reads and displays property bag key/value pairs for a SharePoint site. | Site URL | PnP.PowerShell |
| [Update-SitePropertyBag.ps1](./SharePoint%20Online/Add%20and%20Remove%20Site%20Property%20Bag%20Keys%20and%20Values/Update-SitePropertyBag.ps1) | Adds or updates property bag entries on a SharePoint site from a CSV file. | CSV path, Site URL | PnP.PowerShell |
| [Remove-SitePropertyBag.ps1](./SharePoint%20Online/Add%20and%20Remove%20Site%20Property%20Bag%20Keys%20and%20Values/Remove-SitePropertyBag.ps1) | Removes specified property bag keys from a SharePoint site. | CSV path, Site URL | PnP.PowerShell |

Supporting files:
- `CSV_Template.csv` — Template CSV for property bag key/value operations.
- `Instructions on mapping crawled and managed properties.txt` — Guidance for mapping SharePoint crawled properties to managed properties.

### Project Online — People Picker JavaScript Plugin

JavaScript plugins that add a people picker control to Project Online pages, enabling users to search for and select team members within PWA.

| File | Description |
|------|-------------|
| [ProjectOnline-PeoplePicker.js](./Project%20Online/People%20Picker%20JavaScript%20Plugin/ProjectOnline-PeoplePicker.js) | Core people picker plugin with full search and selection functionality. |
| [ProjectOnline-SinglePersonPeoplePicker.js](./Project%20Online/People%20Picker%20JavaScript%20Plugin/ProjectOnline-SinglePersonPeoplePicker.js) | Variant of the people picker limited to single-person selection. |
| [ProjectOnline-MultiPeoplePicker.js](./Project%20Online/People%20Picker%20JavaScript%20Plugin/ProjectOnline-MultiPeoplePicker.js) | Variant of the people picker supporting multiple-person selection. |

The `pics/` subfolder contains screenshots showing how to configure the plugin in a Project Online Content Editor Web Part.

---

## Prerequisites

| Module | Install Command |
|--------|----------------|
| PnP.PowerShell | `Install-Module -Name PnP.PowerShell` |
| Microsoft.Online.SharePoint.PowerShell | `Install-Module -Name Microsoft.Online.SharePoint.PowerShell` |

## Permissions

- **SharePoint Administrator** or **Site Collection Administrator** — required for property bag and permission level scripts.
- **SharePoint Administrator** — required for tenant-level settings (`Enable-SPORestrictedAccessControl.ps1`).
