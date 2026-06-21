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

### Commands

Repo-wide commands for testing, linting, type-checking, and building. See `docs/agents/commands.md`.

### Notion

Workspace, database IDs, and property mappings used by tracker-primitives. See `docs/agents/notion.md`.

### Domain language

Domain glossary and ADRs live in the Notion workspace — see `docs/agents/notion.md` for the Domain Glossary DB ID and ADRs DB ID. To consult them, use `mcp__notion__notion-fetch` on the respective DB ID. This is the read path for skills that ground in domain language without otherwise needing `tracker-primitives/` (e.g. `/tdd`, `/diagnose`).
