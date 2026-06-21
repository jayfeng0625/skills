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

**Config dir:** `docs/agents/` — holds the relocatable config below. `workflow-config.md` is gitignored (it carries private Notion IDs); re-run `/setup-bonai-skills` after a fresh clone to regenerate it.

### Commands

Repo-wide commands for testing, linting, type-checking, and building. See `commands.md` in the Config dir.

### Workflow backend

**Backend:** notion — selects the `tracker-primitives/notion.md` recipe. The Issues / PRDs / Handoffs database IDs and property mappings live in `workflow-config.md` in the Config dir.

### Domain language

Glossary: `CONTEXT.md` (repo root). ADRs: `docs/adr/` (repo root). Read these files **directly** — they are fixed filesystem conventions, not block-resolved and not under the Config dir. Skills that only read (e.g. `/tdd`, `/diagnose`) ground from them and degrade gracefully when absent.
