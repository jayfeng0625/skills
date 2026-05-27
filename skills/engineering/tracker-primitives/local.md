# Local markdown primitives

Reference backend. All "tracker" state lives in the repo as markdown files. Per-repo config lives in `docs/agents/local.md` (folder paths) — written by `/setup-bonai-skills` when the user picks local.

## Layout

```
.scratch/
  issues/<id>-<slug>.md       ← one file per issue
  prds/<id>-<slug>.md         ← one file per PRD
  handoffs/<date>-<slug>.md   ← one file per handoff
CONTEXT.md                    ← glossary
docs/adr/NNNN-<slug>.md       ← ADRs
```

## Verbs

### `transition state`

Edit the issue file's frontmatter `status:` field to the mapped role string.

### `post triage note`

Append a `## Triage note (<date>)` section to the bottom of the issue file.

### `post agent brief`

Append a `## Agent brief` section to the bottom of the issue file, or write a sibling file at `.scratch/issues/<id>-brief.md` if the body exceeds a comfortable size. Either choice is valid; the file-system has no "child page" structure to mirror Notion's.

### `create issue page`

Create `.scratch/issues/<next-id>-<slug>.md` with frontmatter (title, status, category, blocked_by) and the rendered body. `next-id` = max existing id + 1.

### `create PRD page`

Create `.scratch/prds/<next-id>-<slug>.md` with the PRD body.

### `create handoff page`

Create `.scratch/handoffs/<YYYY-MM-DD>-<slug>.md` with the handoff sections.

### `read glossary`

Read `CONTEXT.md` from the repo root.

### `write glossary entry`

Append to `CONTEXT.md` using the page-body template from `skills/engineering/grill-with-docs/CONTEXT-FORMAT.md`.

### `read ADRs in area`

Read files from `docs/adr/` matching the area folder convention if `docs/agents/local.md` defines one; otherwise read all.

### `create ADR`

Write `docs/adr/NNNN-<slug>.md` using the ADR page-body template. NNNN = max existing + 1.

## Notes

Reference backend; not the Stage 1 default. Useful for solo repos with no Notion workspace.
