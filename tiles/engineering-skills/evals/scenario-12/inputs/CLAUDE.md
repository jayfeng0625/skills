# Project

A TypeScript platform service.

## Agent skills

**Config dir:** `.agent-config/` — holds the relocatable config below (`commands.md` + `workflow-config.md`).

### Commands

Repo-wide commands for testing, linting, type-checking, and building. See `commands.md` in the Config dir.

### Workflow backend

**Backend:** local — selects the `tracker-primitives/local.md` recipe. All tracker state lives in the repo as markdown under `.scratch/`; folder layout is recorded in `workflow-config.md` in the Config dir.

### Domain language

Glossary: `CONTEXT.md` (repo root). ADRs: `docs/adr/` (repo root). Read these files **directly** — they are fixed filesystem conventions, not block-resolved and not under the Config dir. They may be absent; degrade gracefully.
