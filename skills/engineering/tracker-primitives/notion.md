# Notion primitives

Each section maps one abstract verb to its Notion MCP call. All IDs (workspace, databases, property names) come from `docs/agents/notion.md` in the consuming repo. Never hardcode an ID here.

## Lookup

Before any verb, read `docs/agents/notion.md` once at the start of the conversation. Cache the DB IDs and property mappings. If the file is missing, stop and ask the user to run `/setup-bonai-skills`.

## Verbs

### `transition state`

Used by `/triage` to move an issue between states (needs-triage → ready-for-agent, etc).

Tool: `mcp__notion__notion-update-page`
- `page_id`: the issue page ID
- Property to update: the **Status** property name from `docs/agents/notion.md` (canonical role → string mapping)
- Value: the mapped string for the target role (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`)

### `post triage note`

Used by `/triage` to add a comment explaining why a state transition happened.

Tool: `mcp__notion__notion-create-comment`
- Target: the issue page ID
- Body: the triage note in markdown

### `post agent brief`

Used by `/triage` to attach a long, structured work specification to an issue when the issue moves to `ready-for-agent` (or `ready-for-human`). The brief lives as a **child page** of the issue page so it has a stable URL and isn't truncated to Notion's comment length limits.

Tool: `mcp__notion__notion-create-pages`
- Parent: `{ page_id: <issue page id> }`
- Title: short brief name (e.g. "Agent brief: <issue title>")
- Body: rendered from the `AGENT-BRIEF.md` template in `skills/engineering/triage/`

When the issue is later fetched (`mcp__notion__notion-fetch` on the issue page id), the brief appears in the returned children — the AFK agent reads it directly without needing a separate lookup.

### `create issue page`

Used by `/to-issues` and `/triage` to create a new issue in the Issues DB.

Tool: `mcp__notion__notion-create-pages`
- Parent: Issues DB ID from `docs/agents/notion.md`
- Properties: title (required); Status property set to `needs-triage` mapping; Category if `bug` / `enhancement` is known
- Body: rendered from the issue template (see consuming skill for the template)

For dependencies, set the **Blocked by** relation property to the page IDs of blocking issues.

### `create PRD page`

Used by `/to-prd` to create a new PRD in the PRDs DB.

Tool: `mcp__notion__notion-create-pages`
- Parent: PRDs DB ID
- Properties: title (required); other properties per the PRDs DB schema in `docs/agents/notion.md`
- Body: rendered PRD content

### `create handoff page`

Used by `/handoff` to create a handoff page in the Handoffs DB.

Tool: `mcp__notion__notion-create-pages`
- Parent: Handoffs DB ID
- Properties: title (required); date defaults to today
- Body: handoff document with the standard sections (Goal / What's done / Open questions / Suggested skills / Key files / Sensitive-info note)

### `read glossary`

Used by skills that need the domain language to ground their reasoning.

Tool: `mcp__notion__notion-fetch` on the Domain Glossary DB ID
- Fetch all pages in the DB
- Treat each page as one glossary entry (page title = term, page body = definition + aliases)

If the DB returns >50 pages, page through. Cache the result for the conversation.

### `write glossary entry`

Used by `/grill-with-docs` and `/improve-codebase-architecture` when a new term gets resolved during a session.

Tool: `mcp__notion__notion-create-pages`
- Parent: Domain Glossary DB ID
- Title: the canonical term
- Body: uses the page-body template from `skills/engineering/grill-with-docs/CONTEXT-FORMAT.md`

If a page with the same title already exists, use `mcp__notion__notion-update-page` instead of creating a duplicate.

### `read ADRs in area`

Used by skills that need to respect past architectural decisions before suggesting changes.

Tool: `mcp__notion__notion-fetch` on the ADRs DB ID
- Filter to ADRs tagged or filed under the relevant area (the area-tagging property is recorded in `docs/agents/notion.md`)
- Read the page bodies

### `create ADR`

Used by `/grill-with-docs` and `/improve-codebase-architecture` when a hard-to-reverse decision is made during a session.

Tool: `mcp__notion__notion-create-pages`
- Parent: ADRs DB ID
- Title: short decision title
- Body: uses the page-body template from `skills/engineering/grill-with-docs/ADR-FORMAT.md`
- Properties: set the area tag if `docs/agents/notion.md` defines one

## Error handling

If a Notion MCP call fails (auth, missing DB, schema mismatch), stop the verb invocation and tell the user. Do not silently retry or fall back to another backend.
