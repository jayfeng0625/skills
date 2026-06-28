Skills are organized into bucket folders under `skills/`:

- `engineering/` — daily code work
- `productivity/` — daily non-code workflow tools
- `misc/` — kept around but rarely used
- `personal/` — tied to my own setup, not promoted
- `in-progress/` — drafts not yet ready to ship
- `deprecated/` — no longer used

Every skill in `engineering/`, `productivity/`, or `misc/` must have a reference in the top-level `README.md` and an entry in `.claude-plugin/plugin.json`. Skills in `personal/`, `in-progress/`, and `deprecated/` must not appear in either.

Each skill entry in the top-level `README.md` must link the skill name to its `SKILL.md`.

Each bucket folder has a `README.md` that lists every skill in the bucket with a one-line description, with the skill name linked to its `SKILL.md`. Bucket `README.md`s and the top-level `README.md` group entries into **User-invoked** and **Model-invoked**.

Every `SKILL.md` is either user-invoked (`disable-model-invocation: true`, reachable only by the human) or model-invoked (model- or user-reachable). For the full definitions, description conventions, and why a user-invoked skill can invoke model-invoked skills but never another user-invoked one, see [docs/invocation.md](./docs/invocation.md).

## Agent skills

Per-repo agent config for this repo (consumer-state — distinct from what the published tile ships).

**Config dir:** `docs/agents/` — holds the relocatable config below. `workflow-config.md` is gitignored (it carries private Notion IDs) and is maintained by hand; see the `/tracker-notion` skill for the database IDs and property mappings it must contain. Per-repo setup uses upstream's `/setup-matt-pocock-skills`.

### Commands

Repo-wide commands for testing, linting, type-checking, and building. See `commands.md` in the Config dir.

### Workflow backend

**Backend:** notion — the content skills (`/to-prd`, `/to-issues`, `/triage`) produce canonical artifacts and hand off all tracker I/O to the **`/tracker-notion`** backend skill (`skills/engineering/tracker-notion/`), which owns the verb → Notion-MCP-call recipe. `/handoff` likewise hands its document to the backend's Handoffs store (degrading to OS-temp when no backend is configured). The Issues / PRDs / Handoffs database IDs and property mappings live in `workflow-config.md` in the Config dir (gitignored), read by the backend skill at runtime.

### Domain language

Glossary: `CONTEXT.md` (repo root). ADRs: `docs/adr/` (repo root). Read these files **directly** — they are fixed filesystem conventions, not block-resolved and not under the Config dir. Skills that only read (e.g. `/tdd`, `/diagnosing-bugs`) ground from them and degrade gracefully when absent.
