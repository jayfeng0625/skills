# Notion config

## Workspace

ID: <workspace-id>

## Databases

Issues DB:           <id>
PRDs DB:             <id>
Handoffs DB:         <id>
Domain Glossary DB:  <id>
ADRs DB:             <id>

## Issues DB properties

Status (status):
  needs-triage     → "needs-triage"
  needs-info       → "needs-info"
  ready-for-agent  → "ready-for-agent"
  ready-for-human  → "ready-for-human"
  wontfix          → "wontfix"

Category (select):
  bug              → "bug"
  enhancement      → "enhancement"

Blocked by: relation → Issues DB

## ADRs DB properties

Area (optional select): <list of area values, or "n/a">

## Domain Glossary DB properties

(no structured properties — page title = term, page body = definition)

---

## DB seed schemas

These are the property definitions to pass to `mcp__notion__notion-create-database` when the user picks `create` for a missing DB in `/setup-bonai-skills`. The output config section above is what gets written to `docs/agents/notion.md` after IDs are known — this section is the *input* used to build the DBs in the first place.

### Issues DB

- **Name** (title) — required
- **Status** (status) — options: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`; default `needs-triage`
- **Category** (select) — options: `bug`, `enhancement`
- **Blocked by** (relation) — relates to Issues DB (self)

### PRDs DB

- **Name** (title) — required

### Handoffs DB

- **Name** (title) — required
- **Date** (date) — default today

### Domain Glossary DB

- **Name** (title) — required (the canonical term)

### ADRs DB

- **Name** (title) — required
- **Status** (select) — options: `proposed`, `accepted`, `deprecated`, `superseded`
- **Area** (select) — options left empty; user adds per-project as needed
- **Superseded by** (relation) — relates to ADRs DB (self)
