# GitHub (`gh` CLI) primitives

Reference backend. Per-repo config lives in `docs/agents/github.md` (label mapping, repo slug) — written by `/setup-bonai-skills` when the user picks GitHub as the tracker.

## Verbs

### `transition state`

Tool: `gh issue edit <number> --add-label <mapped-label> --remove-label <old-mapped-label>`
- Look up the canonical role → label string mapping in `docs/agents/github.md`.

### `post triage note`

Tool: `gh issue comment <number> --body "<note>"`

### `create issue page`

Tool: `gh issue create --title "<title>" --body "<body>" --label "<status-label>"`
- If the issue has dependencies, append "Blocked by #N" lines to the body — gh has no native dependency relation.

### `create PRD page`

Tool: `gh issue create --title "<title>" --body "<body>" --label "prd"`
- Or, if `docs/agents/github.md` configures a separate PRD repo, target that with `--repo`.

### `create handoff page`

Tool: GitHub does not have a natural handoff store. Use a `gh gist create` with the handoff body, or write to a `.handoffs/` folder in the repo per `docs/agents/github.md`.

### `read glossary`

GitHub has no glossary DB. Read `CONTEXT.md` from the repo root (fallback to repo files when GitHub is the tracker).

### `write glossary entry`

Append to `CONTEXT.md` using the page-body template from `skills/engineering/grill-with-docs/CONTEXT-FORMAT.md`.

### `read ADRs in area`

Read files from `docs/adr/` in the repo.

### `create ADR`

Write a new file under `docs/adr/NNNN-<slug>.md` using the page-body template from `skills/engineering/grill-with-docs/ADR-FORMAT.md`. Numbering: scan existing files, take max+1.

## Notes

This backend is shipped for completeness. `/setup-bonai-skills` does not offer GitHub as a default in Stage 1 — Notion is the primary path.
