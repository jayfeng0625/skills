# Bonai Skills

A personal set of agent skills I use every day, tracking [`mattpocock/skills`](https://github.com/mattpocock/skills) upstream. Packaged as two private tessl tiles under the `bonai-dev` workspace; both ship at the same `YYYY.M.patch` calver. The workflow skills are tracker-agnostic — the content skills hand tracker I/O to a configured backend (a backend skill, or a per-repo recipe), chosen at setup (GitHub, GitLab, local markdown, or any tracker described in prose). This repo runs Notion via the `tracker-notion` backend skill.

| Tile | Skills | Latest |
|---|---|---|
| [`bonai-dev/engineering-skills`](./skills/engineering/) | Daily code-work skills (setup, TDD, implement, bug diagnosis, grilling, prototyping, triage, domain modeling, codebase design, PRD/issue conversion, architecture review, Notion tracker backend) | `2026.6.6` |
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
  sync-upstream.sh    ← merge mattpocock/skills (upstream) into a sync branch
  check-registry.py   ← check/regenerate plugin.json + tile symlinks; verify READMEs
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

Skill bodies never hardcode a tracker. The content skills (`/to-prd`, `/to-issues`, `/triage`) produce canonical artifacts and **hand off** the actual publish / fetch / transition to the repo's configured backend — they never call a tracker's API themselves. The backend is one of two shapes: a **backend skill** (this repo's [`tracker-notion`](./skills/engineering/tracker-notion/SKILL.md), or upstream's `/github`) that owns every MCP / CLI call, or a per-repo **recipe** at `docs/agents/issue-tracker.md` that maps each operation to concrete calls (used for local-markdown and similar). Swapping trackers means swapping the backend, not touching the content skills.

This repo runs **Notion** via the `tracker-notion` skill, which owns the verb → Notion-MCP-call recipe. The private database IDs + property mappings live in the gitignored `docs/agents/workflow-config.md` (maintained by hand), read by the skill at runtime. Repo-wide test/lint/build commands for `/tdd` and `/diagnosing-bugs` live in [`docs/agents/commands.md`](./docs/agents/commands.md). The domain glossary and ADRs are plain filesystem conventions — `CONTEXT.md` and `docs/adr/` at the repo root — read directly, never routed through a tracker.

## Skills

### Engineering (15)

**User-invoked**

- [`ask-matt`](./skills/engineering/ask-matt/SKILL.md) — router over the entire skill system; maps idea→ship flow, on-ramps, and standalone skills
- [`setup-matt-pocock-skills`](./skills/engineering/setup-matt-pocock-skills/SKILL.md) — per-repo config scaffolding (issue tracker, triage labels, domain docs)
- [`implement`](./skills/engineering/implement/SKILL.md) — implement a PRD or issue using /tdd at pre-agreed seams
- [`grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) — grilling that writes glossary / ADRs inline
- [`prototype`](./skills/engineering/prototype/SKILL.md) — throwaway prototype for logic or UI questions
- [`triage`](./skills/engineering/triage/SKILL.md) — issue (and optionally PR) triage state machine; prepares agent briefs for AFK pickup
- [`to-issues`](./skills/engineering/to-issues/SKILL.md) — break a plan into independently-grabbable issues
- [`to-prd`](./skills/engineering/to-prd/SKILL.md) — synthesize current context into a PRD
- [`improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) — find deepening opportunities, HTML-report-driven

**Model-invoked**

- [`tdd`](./skills/engineering/tdd/SKILL.md) — test-driven development loop
- [`diagnosing-bugs`](./skills/engineering/diagnosing-bugs/SKILL.md) — disciplined bug-diagnosis loop
- [`domain-modeling`](./skills/engineering/domain-modeling/SKILL.md) — build and sharpen the project's domain model; updates CONTEXT.md / ADRs inline
- [`codebase-design`](./skills/engineering/codebase-design/SKILL.md) — shared deep-module vocabulary for designing interfaces and seams
- [`resolving-merge-conflicts`](./skills/engineering/resolving-merge-conflicts/SKILL.md) — resolve git merge/rebase conflicts by preserving original intent
- [`tracker-notion`](./skills/engineering/tracker-notion/SKILL.md) — Notion backend for the content skills; publishes PRDs/issues, fetches/lists tickets, applies triage outcomes via the Notion MCP

### Productivity (5)

**User-invoked**

- [`grill-me`](./skills/productivity/grill-me/SKILL.md) — non-code interrogation about a plan / design / talk
- [`teach`](./skills/productivity/teach/SKILL.md) — teach a skill or concept over multiple sessions in a stateful workspace
- [`handoff`](./skills/productivity/handoff/SKILL.md) — cross-session handoff document so a fresh agent can resume work (persisted to the configured backend's Handoffs store, or the OS temp dir when none is configured)
- [`writing-great-skills`](./skills/productivity/writing-great-skills/SKILL.md) — reference for writing and editing skills well; the vocabulary and principles that make a skill predictable

**Model-invoked**

- [`grilling`](./skills/productivity/grilling/SKILL.md) — the reusable interview loop behind the grill skills

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

## Syncing upstream

The fork tracks [`mattpocock/skills`](https://github.com/mattpocock/skills) by **merge**. Run [`scripts/sync-upstream.sh`](./scripts/sync-upstream.sh) — it adds the `upstream` remote (if missing), fetches, cuts a `sync-upstream-<date>` branch, merges `upstream/main`, and finishes by running `check-registry.py --write` to regenerate the manifests. Resolve conflicts with `/resolving-merge-conflicts`, then merge the sync branch back.

Conflicts cluster into four layers, worst first:

- **A — renamed / deleted skills.** Where the fork renamed (`diagnose`→`diagnosing-bugs`, `write-a-skill`→`writing-great-skills`) or dropped (`zoom-out`, `caveman`) an upstream skill, an upstream edit to the old path lands as a modify/delete conflict — re-apply it to the fork's path by hand.
- **B — body-edited skills.** `to-prd`, `to-issues`, `triage`, and `handoff` carry the fork's backend-handoff edits; upstream edits to the same regions conflict. Expect the biggest collision when upstream's own content/backend split lands — its `/github` backend is the twin of our `tracker-notion`.
- **C — registry / overlay files.** `README.md`, `CLAUDE.md`, `CONTEXT.md`, `.claude-plugin/plugin.json`, the bucket READMEs, and `tiles/*` are fork-owned and conflict on almost any upstream skill add/remove. [`check-registry.py`](./scripts/check-registry.py) `--write` regenerates the `plugin.json` manifests and tile symlinks; the READMEs it only verifies and reports (their prose is curated, so it won't rewrite them).
- **D — fork-only files.** `docs/agents/*`, `tracker-notion`, the `tiles/*` evals — upstream has nothing there, so they never conflict.

`scripts/check-registry.py` (no `--write`) doubles as a standalone lint: it fails if any shipped skill is missing from a manifest or README, if an excluded-bucket skill leaks in, or if a bucket count is wrong.

### Local install (escape hatch, skip the registry)

The registry publish lags a merge by several minutes (calver bump → publish → eval). To try a skill change in a target repo *now*, install the local working copy straight into it with [`scripts/install-local.sh`](./scripts/install-local.sh):

```sh
# from inside the consumer repo:
/abs/path/to/skills/scripts/install-local.sh                  # both tiles
/abs/path/to/skills/scripts/install-local.sh engineering-skills   # one tile

# or target another repo without cd-ing into it:
scripts/install-local.sh --target ~/code/app
scripts/install-local.sh --global engineering-skills          # into ~/.tessl
```

It copies each tile to a temp dir with the skill symlinks dereferenced (Tessl excludes symlinks from plugins) and runs `tessl install <copy>` as a file-source install, so the target repo gets a real local copy under its `.tessl/`. The working tree is never mutated. Re-run after each change — it's a one-shot copy, not a live link (`--watch-local` can't be used because the dereferenced copy is transient).

## License

MIT — see [LICENSE](./LICENSE).
