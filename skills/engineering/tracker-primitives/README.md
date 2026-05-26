# Tracker primitives

Engineering skills speak in **abstract verbs**. This folder translates each verb into concrete tool calls for a specific backend.

A skill says: "create issue page with these fields."
The primitives file says: "for Notion, that's `mcp__notion__notion-create-pages` against the Issues DB; for GitHub, that's `gh issue create`; for local, that's a markdown file under `.scratch/`."

Per-repo IDs (database IDs, label strings, file paths) live in `docs/agents/notion.md` or equivalent, written by `/setup-bonai-skills`.

## Controlled vocabulary

Skills may only use these verbs. Adding a new verb requires a recipe in every backend file in this folder **and** an update to the design spec.

| Verb | Used by |
|---|---|
| `transition state` | `/triage` |
| `post triage note` | `/triage` |
| `post agent brief` | `/triage` |
| `create issue page` | `/to-issues`, `/triage` |
| `create PRD page` | `/to-prd` |
| `create handoff page` | `/handoff` |
| `read glossary` | `/tdd`, `/diagnose`, `/grill-with-docs`, `/triage`, `/to-issues`, `/to-prd`, `/improve-codebase-architecture` |
| `write glossary entry` | `/grill-with-docs`, `/improve-codebase-architecture` |
| `read ADRs in area` | `/tdd`, `/diagnose`, `/grill-with-docs`, `/triage`, `/improve-codebase-architecture` |
| `create ADR` | `/grill-with-docs`, `/improve-codebase-architecture` |

## Backends

- [`notion.md`](./notion.md) — primary backend, uses the Notion MCP
- [`gh.md`](./gh.md) — GitHub via `gh` CLI (reference; not Stage 1 default)
- [`local.md`](./local.md) — local markdown files (reference; not Stage 1 default)

## Choosing a backend

`/setup-bonai-skills` picks one backend per repo and writes the per-repo config. Skills then look up the chosen backend from `CLAUDE.md` / `AGENTS.md` and load the matching recipe file from this folder.

## Read verbs without loading primitives

Skills that *only* read (e.g. `/tdd`, `/diagnose`) consume `read glossary` and `read ADRs in area` via the **Domain language** entry in CLAUDE.md / AGENTS.md's `## Agent skills` section, rather than loading this folder. The entry names the source IDs/paths directly so a read happens in one MCP call without the verb-translation layer.

The read verbs stay in the controlled vocabulary above because skills that *also write* (`/grill-with-docs`, plus Stage 2 skills like `/triage`, `/to-issues`, `/improve-codebase-architecture`) keep the read+write pair in the same backend file for symmetry — they already pay the cost of loading this folder for their writes.
