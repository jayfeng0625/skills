# Engineering

Skills for daily code work. All 14 skills below are in the `bonai-dev/engineering-skills` tile manifest at the current `2026.6.5` calver.

- **[setup-bonai-skills](./setup-bonai-skills/SKILL.md)** — Scaffold per-repo config (`commands.md` + `workflow-config.md`, written into a config dir chosen at setup, default `docs/agents/`) that the other engineering skills consume.
- **[tdd](./tdd/SKILL.md)** — Test-driven development with a red-green-refactor loop. Reads commands from the `commands.md` named in the `## Agent skills` block's Config dir; never names a test runner.
- **[diagnosing-bugs](./diagnosing-bugs/SKILL.md)** — Disciplined diagnosis loop: reproduce → minimise → hypothesise → instrument → fix → regression-test.
- **[grill-with-docs](./grill-with-docs/SKILL.md)** — Grilling session that writes glossary entries and ADRs to the project's tracker inline as decisions crystallise.
- **[prototype](./prototype/SKILL.md)** — Build a throwaway prototype to flesh out a design — either a runnable terminal app for state/logic questions, or several radically different UI variations toggleable from one route.
- **[domain-modeling](./domain-modeling/SKILL.md)** — Actively build and sharpen a project's domain model; challenges terms, updates CONTEXT.md and ADRs inline. Model-invoked so other skills can reach it.
- **[codebase-design](./codebase-design/SKILL.md)** — Shared vocabulary for designing deep modules (depth, seams, adapters). Model-invoked reference skill for designing or improving module interfaces.
- **[triage](./triage/SKILL.md)** — Triage issues through a state machine of triage roles; posts agent briefs as child pages of the issue.
- **[implement](./implement/SKILL.md)** — Implement a piece of work based on a PRD or set of issues; uses /tdd at pre-agreed seams and reviews on completion.
- **[resolving-merge-conflicts](./resolving-merge-conflicts/SKILL.md)** — Resolve an in-progress git merge or rebase conflict by understanding original intent and preserving both changes where possible.
- **[ask-matt](./ask-matt/SKILL.md)** — Router over the entire skill system; maps the main idea→ship flow, on-ramps, and standalone skills. Ask this when you're unsure which skill to reach for.
- **[to-issues](./to-issues/SKILL.md)** — Break any plan into independently-grabbable issues using vertical slices; publishes at `ready-for-agent` to skip an extra triage hop.
- **[to-prd](./to-prd/SKILL.md)** — Turn the current conversation context into a PRD; no interview, synthesizes what you already know.
- **[improve-codebase-architecture](./improve-codebase-architecture/SKILL.md)** — Find deepening opportunities in a codebase, informed by the project's domain glossary and ADRs; renders an HTML report.

## Shared

- **[tracker-primitives/](./tracker-primitives/README.md)** — Abstract-verb → MCP/CLI translation recipes (Notion, GitHub, local). Controlled vocabulary of 6 verbs.
