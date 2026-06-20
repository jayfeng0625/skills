---
name: handoff
description: Compacts the current conversation into a structured handoff document (Goal / What's done / Open questions / Suggested skills / Key files / Sensitive-info note) and writes it to the per-repo Handoffs DB tagged with the workstream's Epic. Use when context is approaching limits, the user says "hand off", "pass this to another session", "write a handoff", "summarize for the next agent", or when pausing work that another session must resume.
argument-hint: "What will the next session be used for?"
---

# Handoff

Write a handoff document so a fresh agent can resume this work in a later session. The document lives in the per-repo Handoffs DB; each handoff is tagged with the **Epic** it belongs to (the workstream / feature track within this project).

## Verbs used

- `create handoff page` — writes the handoff to the Handoffs DB
- `list property options` — fetches existing Epic options from the Handoffs DB
- `add property option` — appends a new Epic option without overwriting existing ones

Backend-specific MCP / CLI mappings live in `../tracker-primitives/<backend>.md`.

Optionally read the glossary (`CONTEXT.md`) directly if a term used in the handoff needs a canonical-vocabulary check — a filesystem convention, not a backend verb.

## Process

### 1. Pick the Epic

Before composing the body, ask which **Epic** this handoff belongs to:

- Invoke `list property options` on the Handoffs DB's `Epic` column (DB ID from `workflow-config.md` in the `## Agent skills` block). If the backend doesn't support enumerated properties (e.g. local), skip to free-text.
- Present the existing options as a single AskUserQuestion. Default to the most recently used option if context suggests it (e.g. an in-progress Epic that's been written to today).
- If no existing option fits, offer "Add a new Epic" — when picked, ask for the new Epic name. Invoke `add property option` to append it.

### 2. Compose the body

Use the **canonical section order**:

1. **Goal** — what the next session should accomplish.
2. **What's done** — a tight list of what's already in place. Do not duplicate content already captured in PRDs, plans, ADRs, issues, commits, or diffs — reference them by path/URL instead.
3. **Open questions** — decision points the next session must resolve. Each one names what's at stake and what's blocking it.
4. **Suggested skills** — which engineering / productivity skills the next session should invoke, in expected order. Always mention `superpowers:brainstorming` for design exploration if the open questions are design-shaped; mention `/grill-with-docs` for stress-testing against the project's existing domain artifacts; mention this skill's own write-up tools (`/to-prd`, `/to-issues`, `/triage`) only if downstream conversion is part of the plan.
5. **Key files** — paths the next session will need to read first. Spec docs, recent plans, in-flight skill bodies, the relevant tracker-primitives recipe. Keep it short.
6. **Sensitive-info note** — explicit statement about what's redacted and what isn't. API keys, credentials, PII, internal-only repo paths — these never go into the handoff body. If there's nothing sensitive, say "None — all referenced material is repo-internal or workspace-public."

If the user passed arguments to the slash command, treat them as a description of what the next session will focus on and tailor the Goal accordingly.

### 3. Confirm and write

Show the drafted body to the user before invoking `create handoff page`. If they edit it, accept the edit. Then invoke `create handoff page`:

- Parent: Handoffs DB ID from the workflow config named in the `## Agent skills` block
- Title: short slug summarizing the handoff (e.g. "Stage 2 publish blocker — productivity tile scaffold")
- Properties: `Name` (title), `Date` (today), `Epic` (the value chosen in step 1)
- Body: the composed sections from step 2

If the tracker backend fails (auth error, missing DB, schema mismatch), stop and tell the user — do not fall back to writing a file.

### 4. Confirm

Tell the user the Handoffs DB page URL so they can reference it from the next session.
