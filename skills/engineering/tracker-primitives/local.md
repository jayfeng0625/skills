# Local markdown primitives

Reference backend. All "tracker" state lives in the repo as markdown files. Per-repo config (folder paths) lives in the `workflow-config.md` named by `Config dir:` in the `## Agent skills` block of CLAUDE.md / AGENTS.md — written by `/setup-bonai-skills` when the user picks local. Read it once at the start; name no path here.

## Layout

```
.scratch/
  issues/<id>-<slug>.md       ← one file per issue
  prds/<id>-<slug>.md         ← one file per PRD
  handoffs/<date>-<slug>.md   ← one file per handoff
```

The glossary (`CONTEXT.md`) and ADRs (`docs/adr/`) at repo root are fixed filesystem conventions, not tracker verbs — skills read and write them directly, so they are not part of this backend's verb set.

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

## Notes

Reference backend; not the Stage 1 default. Useful for solo repos with no Notion workspace.
