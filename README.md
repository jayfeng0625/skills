# Bonai Skills

A personal set of agent skills I use every day. Packaged as two private tessl tiles under the `bonai-dev` workspace; both ship at the same YYYY.M.patch calver. The workflow skills are tracker-agnostic (Notion, GitHub, or local markdown via `tracker-primitives`) — Notion is the default at setup.

| Tile | Skills | Latest |
|---|---|---|
| [`bonai-dev/engineering-skills`](./skills/engineering/) | Daily code-work skills (setup, TDD, implement, diagnosis, grilling, prototyping, triage, domain modeling, codebase design, PRD/issue conversion, architecture review, zoom-out, thermo-nuclear quality review) | `2026.6.4` |
| [`bonai-dev/productivity-skills`](./skills/productivity/) | General workflow skills (caveman compression, non-code grilling, teaching, cross-session handoffs, skill authoring, skill quality reference) | `2026.6.4` |

Versions follow `YYYY.M.patch` calver and are published automatically on merge to `main` (see [Development & publishing](#development--publishing)).

Skills lean on the agent to interrogate the user (via `AskUserQuestion`-style flows) rather than prescribing rigid checklists. The set replaces my prior use of the `superpowers` plugin — bonai is standalone and has no superpowers fallback.

## Layout

```
skills/               ← single source of truth for every skill
  engineering/        ← daily code work (tile: bonai-dev/engineering-skills)
    tracker-primitives/ ← shared MCP/CLI recipes for the abstract-verb contract
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
/setup-bonai-skills
```

This writes `commands.md` and `workflow-config.md` into a config dir chosen at setup (default `docs/agents/`): `commands.md` holds the canonical test/lint/typecheck/build commands, and `workflow-config.md` holds the `Backend:` token plus whatever per-repo config that backend needs (for the Notion default: the Issues / PRDs / Handoffs database IDs and property mappings, including the Handoffs DB's `Epic` column). The domain glossary and ADRs live on the filesystem (`CONTEXT.md` + `docs/adr/`), not in any tracker. Engineering skills read these to stay language-agnostic and tracker-agnostic. Most productivity skills are zero-config; the exception is `handoff`, which shares the engineering workflow config because it writes to the Handoffs store via `tracker-primitives`.

## The abstract-verb contract

Skill bodies use only **abstract verbs** — never concrete tool calls. `skills/engineering/tracker-primitives/` translates each verb to the chosen backend (Notion is the default at setup; GitHub and local markdown are also supported). Per-repo config lives in `workflow-config.md`, resolved via the `Config dir:` named in the `## Agent skills` block. See [`tracker-primitives/README.md`](./skills/engineering/tracker-primitives/README.md) for the controlled vocabulary (6 workflow verbs; the glossary/ADR verbs are now filesystem conventions — `CONTEXT.md` + `docs/adr/`).

## Skills

### Engineering (17)

- [`ask-matt`](./skills/engineering/ask-matt/SKILL.md) — router over the entire skill system; maps idea→ship flow, on-ramps, and standalone skills
- [`setup-bonai-skills`](./skills/engineering/setup-bonai-skills/SKILL.md) — per-repo config scaffolding
- [`tdd`](./skills/engineering/tdd/SKILL.md) — test-driven development loop
- [`implement`](./skills/engineering/implement/SKILL.md) — implement a PRD or issue using /tdd at pre-agreed seams
- [`diagnose`](./skills/engineering/diagnose/SKILL.md) — disciplined bug-diagnosis loop
- [`triage-issue`](./skills/engineering/triage-issue/SKILL.md) — investigate a bug, find root cause, create an issue with a TDD fix plan in the configured tracker
- [`domain-modeling`](./skills/engineering/domain-modeling/SKILL.md) — build and sharpen the project's domain model; updates CONTEXT.md / ADRs inline (model-invoked)
- [`codebase-design`](./skills/engineering/codebase-design/SKILL.md) — shared deep-module vocabulary; model-invoked reference for designing interfaces and seams
- [`grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) — grilling that writes glossary / ADRs inline
- [`prototype`](./skills/engineering/prototype/SKILL.md) — throwaway prototype for logic or UI questions
- [`triage`](./skills/engineering/triage/SKILL.md) — issue triage state machine; posts agent briefs as child pages
- [`resolving-merge-conflicts`](./skills/engineering/resolving-merge-conflicts/SKILL.md) — resolve git merge/rebase conflicts by preserving original intent
- [`to-issues`](./skills/engineering/to-issues/SKILL.md) — break a plan into independently-grabbable issues
- [`to-prd`](./skills/engineering/to-prd/SKILL.md) — synthesize current context into a PRD
- [`improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) — find deepening opportunities, HTML-report-driven
- [`zoom-out`](./skills/engineering/zoom-out/SKILL.md) — higher-level perspective on unfamiliar code
- [`thermo-nuclear-code-quality-review`](./skills/engineering/thermo-nuclear-code-quality-review/SKILL.md) — extremely strict maintainability review hunting code-judo simplifications

### Productivity (5)

- [`caveman`](./skills/productivity/caveman/SKILL.md) — ultra-compressed communication mode
- [`grill-me`](./skills/productivity/grill-me/SKILL.md) — non-code interrogation about a plan / design / talk
- [`teach`](./skills/productivity/teach/SKILL.md) — teach a skill or concept over multiple sessions in a stateful workspace
- [`handoff`](./skills/productivity/handoff/SKILL.md) — cross-session handoff documents, written to the Handoffs store with an Epic tag (uses engineering's `tracker-primitives`; needs `/setup-bonai-skills`)
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
