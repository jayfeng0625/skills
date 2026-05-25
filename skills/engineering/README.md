# Engineering

Skills for daily code work. The 5 skills below are in the Stage 1 tile manifest. The rest are present in the repo but not yet customized for bonai — they remain in the bucket for visibility but ship in Stage 2.

## Stage 1 (in `bonai-dev/engineering-skills@2026.05.0`)

- **[setup-bonai-skills](./setup-bonai-skills/SKILL.md)** — Scaffold per-repo config (`docs/agents/commands.md`, `docs/agents/notion.md`) that the other engineering skills consume.
- **[tdd](./tdd/SKILL.md)** — Test-driven development with a red-green-refactor loop. Reads commands from `docs/agents/commands.md`; never names a test runner.
- **[diagnose](./diagnose/SKILL.md)** — Disciplined diagnosis loop: reproduce → minimise → hypothesise → instrument → fix → regression-test.
- **[grill-with-docs](./grill-with-docs/SKILL.md)** — Grilling session that writes glossary entries and ADRs to the project's tracker inline as decisions crystallise.
- **[prototype](./prototype/SKILL.md)** — Build a throwaway prototype to flesh out a design — either a runnable terminal app for state/logic questions, or several radically different UI variations toggleable from one route.

## Stage 2 (in the repo, not yet in the tile manifest)

- **[handoff](./handoff/SKILL.md)** — Compact the current conversation into a handoff document.
- **[triage](./triage/SKILL.md)** — Triage issues through a state machine of triage roles.
- **[to-issues](./to-issues/SKILL.md)** — Break any plan into independently-grabbable issues using vertical slices.
- **[to-prd](./to-prd/SKILL.md)** — Turn the current conversation context into a PRD.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)** — Find deepening opportunities in a codebase, informed by the domain language and ADRs.
- **[zoom-out](./zoom-out/SKILL.md)** — Tell the agent to zoom out and give broader context or a higher-level perspective.

## Shared

- **[tracker-primitives/](./tracker-primitives/README.md)** — Abstract-verb → MCP/CLI translation recipes (Notion, GitHub, local).
