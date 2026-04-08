# Microsoft Sentinel

Scripts and utilities for Microsoft Sentinel.

## Files

### Functions

| File | Description |
|------|-------------|
| [Export_Functions.cmd](./Functions/Export_Functions.cmd) | Windows command script for exporting Microsoft Sentinel functions (analytics rule functions / saved KQL queries) from a Sentinel workspace. |

---

## Usage

Run `Export_Functions.cmd` from a Windows command prompt or PowerShell terminal. Ensure you are authenticated to Azure and have the necessary permissions on the target Sentinel workspace before running the script.

## Permissions

- **Microsoft Sentinel Reader** (minimum) — to export functions.
- **Microsoft Sentinel Contributor** — to create or modify functions.
