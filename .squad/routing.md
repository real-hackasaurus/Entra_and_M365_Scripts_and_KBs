# Work Routing

How to decide who handles what.

## Routing Table

| Work Type | Route To | Examples |
|-----------|----------|----------|
| Azure platform, Graph API, Sentinel | Azure Admin | Azure resource scripts, Graph API queries, REST endpoints, Sentinel functions |
| Entra ID, identity, groups, users, licensing | Entra Admin | Group membership, guest invitations, license reports, bulk user operations |
| M365 Defender, MDCA, MDO, threat detection | Defender Admin | Advanced hunting queries, anti-phishing rules, Safe Links/Attachments, alerts |
| M365 Purview, DLP, eDiscovery, MIP, retention | Purview Admin | DLP policies, eDiscovery searches, retention labels, MIP configuration, OME, audit |
| SharePoint Online, M365 Core Services | Purview Admin | SPO scripts, permission levels, restricted access, property bags |
| General requests (no agent named) | Project Manager | Default — analyzes, delegates, coordinates across agents |
| Cross-domain tasks | Project Manager | Work spanning multiple domains (e.g., Entra + Purview) |
| Code review | Project Manager | Review PRs, check quality, suggest improvements |
| Scope & priorities | Project Manager | What to build next, trade-offs, decisions |
| Issue triage | Project Manager | Analyze new issues, assign to the right agent |
| Session logging | Scribe | Automatic — never needs routing |

## Issue Routing

| Label | Action | Who |
|-------|--------|-----|
| `squad` | Triage: analyze issue, assign `squad:{member}` label | Project Manager |
| `squad:{name}` | Pick up issue and complete the work | Named member |

### How Issue Assignment Works

1. When a GitHub issue gets the `squad` label, the **Lead** triages it — analyzing content, assigning the right `squad:{member}` label, and commenting with triage notes.
2. When a `squad:{member}` label is applied, that member picks up the issue in their next session.
3. Members can reassign by removing their label and adding another member's label.
4. The `squad` label is the "inbox" — untriaged issues waiting for Lead review.

## Rules

1. **Eager by default** — spawn all agents who could usefully start work, including anticipatory downstream work.
2. **Scribe always runs** after substantial work, always as `mode: "background"`. Never blocks.
3. **Quick facts → coordinator answers directly.** Don't spawn an agent for "what port does the server run on?"
4. **When two agents could handle it**, pick the one whose domain is the primary concern.
5. **"Team, ..." → fan-out.** Spawn all relevant agents in parallel as `mode: "background"`.
6. **Anticipate downstream work.** If a feature is being built, spawn the tester to write test cases from requirements simultaneously.
7. **Issue-labeled work** — when a `squad:{member}` label is applied to an issue, route to that member. The Lead handles all `squad` (base label) triage.
