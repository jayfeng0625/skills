# Unbake tracker config location from skill bodies

Builds on [0001](./0001-explicit-setup-pointer-only-for-hard-dependencies.md).

## Context

The upstream baseline (`mattpocock/skills`, fully contained in our history at the fork point — no drift since) ships **only templates and abstract-referencing skill bodies**. `/setup-<x>-skills` *generates* per-repo config (`docs/agents/*.md` + an `## Agent skills` block in CLAUDE.md/AGENTS.md) into the **consuming** repo; the skills repo commits none of it, and skill bodies reference the tracker abstractly or via that block.

Our fork diverged in three ways that bake config in:

1. Committed concrete config (`docs/agents/notion.md`, `docs/agents/commands.md`) into the **skills repo itself**, and put concrete pointers in this repo's CLAUDE.md.
2. **Hardcoded the literal path `docs/agents/notion.md`** into skill bodies (`to-prd`, `grill-with-docs`, `handoff`, `tdd`). Every consumer who installs the tile inherits "read `docs/agents/notion.md`" — forcing both that path *and* the Notion backend.
3. Moved the domain glossary + ADRs into Notion DBs, duplicating the `CONTEXT.md` + `docs/adr/` filesystem convention the fork still carries.

## Decision

Strip back to upstream's **referencing discipline**, but keep the fork's `tracker-primitives/` verb-abstraction (its genuine value-add: adding a backend is one file, and skill bodies stay backend-agnostic). Concretely:

1. **Keep `tracker-primitives/`** for the workflow verbs (issues / PRDs / handoffs). Adopt upstream's discipline, not its structure.
2. **Skill bodies stop hardcoding `docs/agents/notion.md`.** They resolve the tracker through the `## Agent skills` block pointer, or reference it abstractly per [0001](./0001-explicit-setup-pointer-only-for-hard-dependencies.md)'s hard/soft split.
3. **The published tile commits no concrete config** — only templates + recipes. This repo's own generated config is gitignored as consumer-state, never shipped.
4. **Footprint shape A:** setup generates a **role-named** `workflow-config.md` (not `notion.md` — "tracker" alone is avoided per the glossary, which reserves it for the narrower **Issue tracker**) plus an explicit `Backend:` field in the block so a skill deterministically loads `tracker-primitives/<backend>.md`. `commands.md` stays a separate file (used by `tdd`/`diagnosing-bugs`, which never touch the workflow backend), but lives in the same configurable dir and is block-resolved like `workflow-config.md`.
5. **Config directory is configurable at setup** — default `docs/agents/`, one override prompt, and the chosen **directory is recorded once in the block** as a single `Config dir:` value; `workflow-config.md` and `commands.md` are conventional filenames within it. `docs/agents/` stops being a constant in skill bodies and becomes a value the block carries.
6. **Per-repo scope, container per project.** No global/hybrid config for now.
7. **Glossary + ADRs revert to the filesystem** (`CONTEXT.md` + `docs/adr/`); the two Notion DBs (Domain Glossary, ADRs) drop out of the tracker config. `grill-with-docs` and `improve-codebase-architecture` write to files, not Notion. The 4 glossary/ADR verbs leave `tracker-primitives/` and become filesystem conventions. `tdd`/`diagnosing-bugs` ground from files, degrade gracefully, never load config.

**Fixed anchor:** the `## Agent skills` block in CLAUDE.md/AGENTS.md at repo root is the *only* thing that names the path of **relocatable** config (`workflow-config.md` + `commands.md`, via the single `Config dir:` value) and the only thing that cannot move — it is the always-loaded file that lets a skill discover config without being told where it is. `tracker-primitives/<backend>.md` recipes resolve that path **through the block** and name no path themselves.

**Two config regimes.** This splits per-repo config into two kinds, and skills treat them differently:

1. **Block-resolved / relocatable** — `workflow-config.md` (backend-routed via `Backend:`, carries the private DB IDs → gitignorable) and `commands.md` (committed, no secrets). Their location is the block's `Config dir:`; nothing else names it.
2. **Fixed filesystem conventions** — `CONTEXT.md` (glossary) + `docs/adr/` (ADRs) at repo root, named **directly** by skills (no block indirection). This is the regime decision 7 reverts the glossary/ADRs into.

## Consequences

- A consumer can install the tile, run setup once, and point the tracker at any path — including a gitignored one — without editing any skill body.
- Gitignored config is **first-class and intended** (this is a personal, single-user setup pointing at private Notion pages). Trade-off: gitignored config is not committed, so a fresh clone / teammate / CI agent has no config and must re-run setup. This is acceptable only while solo — revisit when the repo is well-tuned and worth sharing/standardizing.
- `workflow-config.md` shrinks to three DB IDs (Issues, PRDs, Handoffs). The block's "Domain language" entry just names `CONTEXT.md` + `docs/adr/` (regime 2, repo-root, not under `Config dir:`).
- Switching backends becomes a one-block edit (`Backend:` field + file contents), touching no skill body and no path.
