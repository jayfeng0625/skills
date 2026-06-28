# Bonai Skills

A collection of agent skills (slash commands and behaviors) loaded by Claude Code. Skills are organized into buckets and consumed by per-repo configuration written by `/setup-matt-pocock-skills` under `docs/agents/`.

## Language

**Workflow backend**:
The per-repo tool that hosts a repo's **Issues**, **PRDs**, and **Handoffs** — one of Notion, GitHub, or a local `.scratch/` markdown convention. Selected by the `Backend:` token in the `## Agent skills` block; its IDs/paths live in `workflow-config.md`. The backend's recipe — each tracker operation mapped to concrete calls — lives in a **backend skill** (this repo: `tracker-notion`) or, for a config-doc backend, `docs/agents/issue-tracker.md`. The content skills hand their artifacts to the backend rather than calling the tracker themselves.
_Avoid_: tracker (ambiguous with **Issue tracker**), backlog backend

**Issue tracker**:
The **Issue**-hosting facet of the **Workflow backend** — where `to-issues`, `triage`, and `qa` read and write Issues. PRDs and Handoffs are sibling stores in the same backend, not Issues.
_Avoid_: backlog manager, backlog backend, issue host

**Issue**:
A single tracked unit of work in the **Issue tracker** — a bug, task, or vertical slice produced by `to-issues`. A **PRD** or a **Handoff** is not an Issue.
_Avoid_: ticket (use only when quoting external systems that call them tickets)

**Triage role**:
A canonical state-machine label applied to an **Issue** during triage (e.g. `needs-triage`, `ready-for-agent`). Each role maps to a real label string in the **Issue tracker** via the role→string mapping in `workflow-config.md` (for the Notion backend, the Issues DB `Status` select).

## Relationships

- A **Workflow backend** hosts **Issues** (via its **Issue tracker**), **PRDs**, and **Handoffs**
- An **Issue tracker** holds many **Issues**
- An **Issue** carries one **Triage role** at a time

## Flagged ambiguities

- "backlog" was previously used to mean both the *tool* hosting issues and the *body of work* inside it — resolved: the tool is the **Issue tracker**; "backlog" is no longer used as a domain term.
- "backlog backend" / "backlog manager" — resolved: collapsed into **Issue tracker**.
- "tracker" / `tracker.md` was proposed as the unified config filename but conflates the umbrella **Workflow backend** with the narrower **Issue tracker** — resolved: the config file is `workflow-config.md`; "tracker" alone is avoided as a domain *noun*. (The Notion **backend skill** is named `tracker-notion` — a proper skill name for the backend, not the bare domain term.)
- The Notion backend's recipe moved out of `docs/agents/issue-tracker.md` into the `tracker-notion` **backend skill** — content skills now hand off to a backend (skill or config-doc) rather than resolving a recipe doc inline. Config-doc backends (local markdown, etc.) still use `issue-tracker.md`.
