# Bonai Skills

A personal set of agent skills I use every day, tracking [`mattpocock/skills`](https://github.com/mattpocock/skills) upstream. Packaged as two private tessl tiles under the `bonai-dev` workspace; both ship at the same `YYYY.M.patch` calver. The workflow skills are tracker-agnostic — the per-repo issue tracker is chosen at setup (GitHub, GitLab, local markdown, or any tracker described in prose). This repo runs Notion.

| Tile | Skills | Latest |
|---|---|---|
| [`bonai-dev/engineering-skills`](./skills/engineering/) | Daily code-work skills (setup, TDD, implement, bug diagnosis, grilling, prototyping, triage, domain modeling, codebase design, PRD/issue conversion, architecture review) | `2026.6.6` |
| [`bonai-dev/productivity-skills`](./skills/productivity/) | General workflow skills (non-code grilling, the reusable interview loop, teaching, cross-session handoffs, skill authoring, skill quality reference) | `2026.6.6` |

Versions follow `YYYY.M.patch` calver and are published automatically on merge to `main` (see [Development & publishing](#development--publishing)).

Skills lean on the agent to interrogate the user (via `AskUserQuestion`-style flows) rather than prescribing rigid checklists. The set replaces my prior use of the `superpowers` plugin — bonai is standalone and has no superpowers fallback.

## Layout

```
skills/               ← single source of truth for every skill (tracks mattpocock/skills)
  engineering/        ← daily code work (tile: bonai-dev/engineering-skills)
  productivity/       ← daily non-code workflow (tile: bonai-dev/productivity-skills)
  misc/               ← kept around but rarely used
  personal/           ← tied to my own setup, not promoted
  in-progress/        ← drafts not yet ready to ship
  deprecated/         ← no longer used
tiles/                ← packaging roots; each tile has .tessl-plugin/plugin.json,
  engineering-skills/   its skills symlinked from skills/, and evals/ scenarios
  productivity-skills/
scripts/
  tessl-with-tiles.sh ← run any tessl command against the tiles (materializes the symlinks)
```

## How to install (consumer side)

In a target repo:

```sh
tessl install bonai-dev/engineering-skills
tessl install bonai-dev/productivity-skills
```

(Append `@<version>` to pin a specific calver release; omitting it installs the latest.)

Then run the setup skill once per repo:

```
/setup-matt-pocock-skills
```

This is prompt-driven: it explores the repo, then walks you through three choices — **issue tracker** (where issues live), **triage labels** (the strings for the canonical triage roles), and **domain docs** (where `CONTEXT.md` + ADRs live) — and writes the per-repo config under `docs/agents/` plus an `## Agent skills` block in `CLAUDE.md` / `AGENTS.md`. The engineering skills read that block to stay language- and tracker-agnostic.

## Tracker configuration

Skill bodies never hardcode a tracker. They speak in terms of "the issue tracker" and delegate the *how* to a per-repo recipe written at setup: [`docs/agents/issue-tracker.md`](./docs/agents/issue-tracker.md) maps each tracker operation (publish, fetch, list, comment, transition state, attach an agent brief) to concrete calls for the chosen backend.

This repo runs **Notion**: the recipe lives in `docs/agents/issue-tracker.md` and the private database IDs + property mappings in the gitignored `docs/agents/workflow-config.md` (maintained by hand). Repo-wide test/lint/build commands for `/tdd` and `/diagnosing-bugs` live in [`docs/agents/commands.md`](./docs/agents/commands.md). The domain glossary and ADRs are plain filesystem conventions — `CONTEXT.md` and `docs/adr/` at the repo root — read directly, never routed through a tracker.

## Skills

### Engineering (14)

- [`ask-matt`](./skills/engineering/ask-matt/SKILL.md) — router over the entire skill system; maps idea→ship flow, on-ramps, and standalone skills
- [`setup-matt-pocock-skills`](./skills/engineering/setup-matt-pocock-skills/SKILL.md) — per-repo config scaffolding (issue tracker, triage labels, domain docs)
- [`tdd`](./skills/engineering/tdd/SKILL.md) — test-driven development loop
- [`implement`](./skills/engineering/implement/SKILL.md) — implement a PRD or issue using /tdd at pre-agreed seams
- [`diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md) — disciplined bug-diagnosis loop
- [`domain-modeling`](./skills/engineering/domain-modeling/SKILL.md) — build and sharpen the project's domain model; updates CONTEXT.md / ADRs inline (model-invoked)
- [`codebase-design`](./skills/engineering/codebase-design/SKILL.md) — shared deep-module vocabulary; model-invoked reference for designing interfaces and seams
- [`grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) — grilling that writes glossary / ADRs inline
- [`prototype`](./skills/engineering/prototype/SKILL.md) — throwaway prototype for logic or UI questions
- [`triage`](./skills/engineering/triage/SKILL.md) — issue (and optionally PR) triage state machine; prepares agent briefs for AFK pickup
- [`resolving-merge-conflicts`](./skills/engineering/resolving-merge-conflicts/SKILL.md) — resolve git merge/rebase conflicts by preserving original intent
- [`to-issues`](./skills/engineering/to-issues/SKILL.md) — break a plan into independently-grabbable issues
- [`to-prd`](./skills/engineering/to-prd/SKILL.md) — synthesize current context into a PRD
- [`improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) — find deepening opportunities, HTML-report-driven

### Productivity (5)

- [`grill-me`](./skills/productivity/grill-me/SKILL.md) — non-code interrogation about a plan / design / talk
- [`grilling`](./skills/productivity/grilling/SKILL.md) — the reusable interview loop behind the grill skills (model-invoked)
- [`teach`](./skills/productivity/teach/SKILL.md) — teach a skill or concept over multiple sessions in a stateful workspace
- [`handoff`](./skills/productivity/handoff/SKILL.md) — cross-session handoff document so a fresh agent can resume work (written to the OS temp dir)
- [`writing-great-skills`](./skills/productivity/writing-great-skills/SKILL.md) — reference for writing and editing skills well; the vocabulary and principles that make a skill predictable

### Misc (4)

Kept around but rarely used — not part of either published tile.

- [`git-guardrails-claude-code`](./skills/misc/git-guardrails-claude-code/SKILL.md) — Claude Code hooks that block dangerous git commands (push, reset --hard, clean, etc.) before they execute
- [`migrate-to-shoehorn`](./skills/misc/migrate-to-shoehorn/SKILL.md) — migrate test files from `as` type assertions to @total-typescript/shoehorn
- [`scaffold-exercises`](./skills/misc/scaffold-exercises/SKILL.md) — create exercise directory structures with sections, problems, solutions, and explainers
- [`setup-pre-commit`](./skills/misc/setup-pre-commit/SKILL.md) — set up Husky pre-commit hooks with lint-staged, Prettier, type checking, and tests

## Development & publishing

Each tile under `tiles/` is a Tessl plugin: a `.tessl-plugin/plugin.json` manifest, the tile's skills symlinked from `skills/`, and an `evals/` folder of scenarios that measure the skills' impact.

Because the skills are symlinked (single source of truth in `skills/`) and Tessl excludes symlinks from plugins, run every tile command through the wrapper — it materializes the symlinks into real files for the duration of the command and restores them afterwards:

```sh
scripts/tessl-with-tiles.sh plugin lint    tiles/engineering-skills
scripts/tessl-with-tiles.sh plugin pack    tiles/engineering-skills
scripts/tessl-with-tiles.sh eval run       tiles/engineering-skills   # produces the registry Impact score
scripts/tessl-with-tiles.sh plugin publish tiles/engineering-skills
```

Install the CLI with `curl -fsSL https://get.tessl.io | sh` and authenticate via `tessl login` (or a `TESSL_TOKEN` in the environment). Canonical repo commands live in [`docs/agents/commands.md`](./docs/agents/commands.md).

**Releases are automated.** On merge to `main`, [`.github/workflows/publish.yml`](./.github/workflows/publish.yml) computes the next `YYYY.M.patch` version, bumps every tile manifest, publishes the tiles, and commits the bump back. It needs a `TESSL_TOKEN` repo secret with publish permission in `bonai-dev`.

## License

MIT — see [LICENSE](./LICENSE).
