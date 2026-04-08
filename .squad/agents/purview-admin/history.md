# Purview Admin — History

## Project Context

- **Project:** Entra_and_M365_Scripts_and_KBs — Scripts and knowledge bases for managing Azure, Entra ID, M365 Defender, and M365 Purview.
- **User:** Wes Blackwell
- **Stack:** PowerShell, Exchange Online PowerShell, Security & Compliance PowerShell
- **Key directories:** `M365 Purview/DLP/`, `M365 Purview/eDiscovery/`, `M365 Purview/MIP/`, `M365 Purview/OME/`, `M365 Purview/Retention/Labels/`, `M365 Purview/Retention/Policies/`, `M365 Purview/Audit/`, `M365 Core Services/`

## Learnings

<!-- Append new learnings below this line -->
- **2026-04-08 — Retention folder reorganization:** Consolidated the two confusingly-named retention folders (`Retention Labels and Policies (Retention Labels)/` and `Retention Policies (Not Labels or MRM)/`) into a clean `Retention/Labels/` and `Retention/Policies/` hierarchy. Used `git mv` for all 13 files to preserve git history. Key directories under `M365 Purview/` are now: Audit, DLP, eDiscovery, MIP, OME, Retention (with Labels and Policies subfolders).
