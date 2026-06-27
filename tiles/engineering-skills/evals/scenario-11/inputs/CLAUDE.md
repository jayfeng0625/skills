# Billing Service

A Node.js subscription-billing service.

## Agent skills

**Config dir:** `docs/agents/` — holds the relocatable config below (`commands.md` + `workflow-config.md`).

### Commands

Repo-wide commands for testing, linting, type-checking, and building. See `commands.md` in the Config dir.

### Workflow backend

**Backend:** notion — selects the `tracker-primitives/notion.md` recipe. The Issues / PRDs / Handoffs database IDs and property mappings live in `workflow-config.md` in the Config dir.

### Domain language

Glossary: `CONTEXT.md` (repo root). ADRs: `docs/adr/` (repo root). Read these files **directly** — they are fixed filesystem conventions, not block-resolved and not under the Config dir. Skills that only read (e.g. `/tdd`, `/diagnosing-bugs`) ground from them and degrade gracefully when absent.
