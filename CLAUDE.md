Skills are organized into bucket folders under `skills/`:

- `engineering/` — daily code work
- `productivity/` — daily non-code workflow tools
- `misc/` — kept around but rarely used
- `personal/` — tied to my own setup, not promoted
- `in-progress/` — drafts not yet ready to ship
- `deprecated/` — no longer used

Every skill in `engineering/`, `productivity/`, or `misc/` must have a reference in the top-level `README.md` and an entry in `.claude-plugin/plugin.json`. Skills in `personal/`, `in-progress/`, and `deprecated/` must not appear in either.

Each skill entry in the top-level `README.md` must link the skill name to its `SKILL.md`.

Each bucket folder has a `README.md` that lists every skill in the bucket with a one-line description, with the skill name linked to its `SKILL.md`.

## Agent skills

Per-repo agent config for this repo (consumer-state — distinct from what the published tile ships).

**Config dir:** `docs/agents/` — holds the relocatable config below. `workflow-config.md` is gitignored (it carries private Notion IDs) and is maintained by hand; see `docs/agents/issue-tracker.md` for the database IDs and property mappings it must contain. Per-repo setup uses upstream's `/setup-matt-pocock-skills`.

### Commands

Repo-wide commands for testing, linting, type-checking, and building. See `commands.md` in the Config dir.

### Workflow backend

**Backend:** notion — the Notion recipe (each tracker verb → its Notion MCP call) lives in `docs/agents/issue-tracker.md`. The Issues / PRDs / Handoffs database IDs and property mappings live in `workflow-config.md` in the Config dir.

### Domain language

Glossary: `CONTEXT.md` (repo root). ADRs: `docs/adr/` (repo root). Read these files **directly** — they are fixed filesystem conventions, not block-resolved and not under the Config dir. Skills that only read (e.g. `/tdd`, `/diagnosing-bugs`) ground from them and degrade gracefully when absent.
