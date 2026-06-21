# Workflow config

Backend-routed config for the workflow tracker (Issues / PRDs / Handoffs).

## Backend

local

## Layout

All tracker state lives under `.scratch/`:

```
.scratch/
  issues/<id>-<slug>.md
  prds/<id>-<slug>.md
  handoffs/<date>-<slug>.md
```

`<id>` = max existing id in the folder + 1. Issue files carry frontmatter (title, status, category, blocked_by). The glossary (`CONTEXT.md`) and ADRs (`docs/adr/`) are repo-root filesystem conventions, not tracker state.
