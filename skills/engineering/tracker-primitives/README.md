# Tracker primitives

Engineering skills speak in **abstract verbs**. This folder translates each verb into concrete tool calls for a specific backend.

A skill says: "create issue page with these fields."
The primitives file says: "for Notion, that's `mcp__notion__notion-create-pages` against the Issues DB; for GitHub, that's `gh issue create`; for local, that's a markdown file under `.scratch/`."

Per-repo IDs (database IDs, label strings, file paths) live in `workflow-config.md`, located via the `Config dir:` value named in the `## Agent skills` block of CLAUDE.md / AGENTS.md, written by `/setup-bonai-skills`.

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

## Backends

- [`notion.md`](./notion.md) — primary backend, uses the Notion MCP
- [`gh.md`](./gh.md) — GitHub via `gh` CLI (reference; not Stage 1 default)
- [`local.md`](./local.md) — local markdown files (reference; not Stage 1 default)

## Choosing a backend

`/setup-bonai-skills` picks one backend per repo and writes the per-repo config. Skills then look up the chosen backend from `CLAUDE.md` / `AGENTS.md` and load the matching recipe file from this folder.

## Glossary and ADRs are not tracker verbs

The domain glossary and ADRs are **fixed filesystem conventions**, not backend-routed verbs: the glossary lives in `CONTEXT.md` and ADRs live under `docs/adr/`, both at repo root. Skills read and write them **directly** as files — never through this folder, and never through the `Config dir:` indirection used for `workflow-config.md`.

Skills locate these via the **Domain language** entry in CLAUDE.md / AGENTS.md's `## Agent skills` section, which names `CONTEXT.md` + `docs/adr/` directly. Both read-only consumers (`/tdd`, `/diagnosing-bugs`, `/triage`, `/to-issues`, `/to-prd`) and read+write consumers (`/grill-with-docs`, `/improve-codebase-architecture`) use this filesystem path; none load a tracker recipe for glossary or ADR access.
