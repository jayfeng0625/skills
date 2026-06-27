# Issue tracker: Notion

Issues and PRDs for this repo live in Notion databases, accessed through the Notion MCP. This file is the per-repo recipe the engineering skills (`/to-issues`, `/to-prd`, `/triage`) resolve when they say "the issue tracker" — it maps each tracker operation to a concrete Notion MCP call.

All database IDs and property mappings live in **`docs/agents/workflow-config.md`** (gitignored — it holds the private workspace IDs). Read that file once at the start of any skill that touches the tracker and cache the IDs + property mappings for the conversation. If it is missing, stop and ask the user to recreate it before proceeding.

**Never hardcode a Notion ID here or in a skill body — always resolve it from `workflow-config.md`.**

## Conventions

- **Create an issue / "publish to the issue tracker"** — `mcp__notion__notion-create-pages`, parent = Issues DB ID. Set the title (required), the **Status** property to the `needs-triage` role string (or the instructed role), and **Category** (`bug` / `enhancement`) when known. Body = the consuming skill's issue template. For dependencies, set the **Blocked by** relation to the blocking issues' page IDs.
- **Create a PRD** — `mcp__notion__notion-create-pages`, parent = **PRDs DB** ID. `/to-prd` says "publish to the project issue tracker"; for this repo a PRD goes to the PRDs DB, not the Issues DB. Apply `ready-for-agent` via the Status property as instructed.
- **Read / "fetch the relevant ticket"** — `mcp__notion__notion-fetch` on the page ID. Child pages (e.g. an attached agent brief) are returned in the response, so no separate lookup is needed. If given a title rather than an ID, resolve it via the list operation first.
- **List / query issues** — `mcp__notion__notion-query-data-sources` against the Issues DB data source, filtering on the Status property. Present oldest-first per the triage buckets.
- **Comment / "post triage note"** — `mcp__notion__notion-create-comment` on the issue page ID; body = the note in markdown. Per `/triage`, every triage comment must start with the standard disclaimer.
- **Apply a triage label / "transition state"** — `mcp__notion__notion-update-page` on the issue page ID, setting the **Status** property to the mapped role string. The canonical-role → string mapping lives in `workflow-config.md`. The five canonical roles: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`.
- **Close as wontfix** — transition state to `wontfix`, plus a triage note explaining why.
- **Attach an agent brief** — when an issue moves to `ready-for-agent` / `ready-for-human`, create the brief as a **child page** of the issue (`mcp__notion__notion-create-pages` with `parent: { page_id: <issue page id> }`) so it has a stable URL and isn't truncated by comment-length limits. Body = the `AGENT-BRIEF.md` template in `skills/engineering/triage/`.

## Adding a Select option (Epic and similar)

To append an option to a Select property without overwriting the existing ones:

1. `mcp__notion__notion-fetch` the DB ID and read `properties.<PropertyName>.select.options`.
2. `mcp__notion__notion-update-data-source` with `ALTER COLUMN "<PropertyName>" SET SELECT(...)` listing **all** existing options **plus** the new one.

Never use `ADD COLUMN` — that adds a new property, not a new option.

## Pull requests as a triage surface

**N/A — Notion has no pull requests.** `/triage` processes issues only for this repo. (The PR-as-request-surface flag applies only to GitHub / GitLab trackers.)

## Error handling

If a Notion MCP call fails (auth, missing DB, schema mismatch), stop the operation and tell the user. Do not silently retry or fall back to another backend.

## When a skill says "publish to the issue tracker"

Create a page in the Issues DB (the PRDs DB for `/to-prd`). See Conventions above.

## When a skill says "fetch the relevant ticket"

`mcp__notion__notion-fetch` on the page ID, or resolve the title via `mcp__notion__notion-query-data-sources` first.
