# Engineering

Skills for daily code work. All 11 skills below are in the `bonai-dev/engineering-skills` tile manifest at the current `2026.5.28` calver.

- **[setup-bonai-skills](./setup-bonai-skills/SKILL.md)** — Scaffold per-repo config (`docs/agents/commands.md`, `docs/agents/notion.md`) that the other engineering skills consume.
- **[tdd](./tdd/SKILL.md)** — Test-driven development with a red-green-refactor loop. Reads commands from `docs/agents/commands.md`; never names a test runner.
- **[diagnose](./diagnose/SKILL.md)** — Disciplined diagnosis loop: reproduce → minimise → hypothesise → instrument → fix → regression-test.
- **[grill-with-docs](./grill-with-docs/SKILL.md)** — Grilling session that writes glossary entries and ADRs to the project's tracker inline as decisions crystallise.
- **[prototype](./prototype/SKILL.md)** — Build a throwaway prototype to flesh out a design — either a runnable terminal app for state/logic questions, or several radically different UI variations toggleable from one route.
- **[triage](./triage/SKILL.md)** — Triage issues through a state machine of triage roles; posts agent briefs as child pages of the issue.
- **[to-issues](./to-issues/SKILL.md)** — Break any plan into independently-grabbable issues using vertical slices; publishes at `ready-for-agent` to skip an extra triage hop.
- **[to-prd](./to-prd/SKILL.md)** — Turn the current conversation context into a PRD; no interview, synthesizes what you already know.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)** — Find deepening opportunities in a codebase, informed by the project's domain glossary and ADRs; renders an HTML report.
- **[zoom-out](./zoom-out/SKILL.md)** — Tell the agent to zoom out and give broader context or a higher-level perspective.
- **[handoff](./handoff/SKILL.md)** — Compact the current conversation into a handoff document, written to the per-repo Handoffs DB with an Epic tag.

## Shared

- **[tracker-primitives/](./tracker-primitives/README.md)** — Abstract-verb → MCP/CLI translation recipes (Notion, GitHub, local). Controlled vocabulary of 10 verbs.
