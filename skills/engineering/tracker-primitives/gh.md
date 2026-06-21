# GitHub (`gh` CLI) primitives

Reference backend. Per-repo config (label mapping, repo slug) lives in the `workflow-config.md` named by `Config dir:` in the `## Agent skills` block of CLAUDE.md / AGENTS.md — written by `/setup-bonai-skills` when the user picks GitHub as the tracker. Read it once at the start (the block is already loaded by the time this recipe runs); name no path here.

## Verbs

### `transition state`

Tool: `gh issue edit <number> --add-label <mapped-label> --remove-label <old-mapped-label>`
- Look up the canonical role → label string mapping in `workflow-config.md`.

### `post triage note`

Tool: `gh issue comment <number> --body "<note>"`

### `post agent brief`

GitHub has no native "child page" concept on an issue. Two equivalents:

- **Long comment** (Stage 1 fallback): `gh issue comment <number> --body "<rendered brief>"`. Works but loses the URL-stable child-page property of the Notion backend.
- **Linked discussion / wiki page**: open a corresponding wiki page or repo discussion via `gh api`, then link to it from a short `gh issue comment` on the issue.

Stage 2 ships the long-comment form by default for the gh backend; consuming skills (`/triage`) treat it as the fallback path when the chosen backend is gh.

### `create issue page`

Tool: `gh issue create --title "<title>" --body "<body>" --label "<status-label>"`
- If the issue has dependencies, append "Blocked by #N" lines to the body — gh has no native dependency relation.

### `create PRD page`

Tool: `gh issue create --title "<title>" --body "<body>" --label "prd"`
- Or, if `workflow-config.md` configures a separate PRD repo, target that with `--repo`.

### `create handoff page`

Tool: GitHub does not have a natural handoff store. Use a `gh gist create` with the handoff body, or write to a `.handoffs/` folder in the repo per `workflow-config.md`.

## Notes

This backend is shipped for completeness. `/setup-bonai-skills` does not offer GitHub as a default in Stage 1 — Notion is the primary path.
