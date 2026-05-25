# Bonai Skills — Customization & Tessl Publishing Design

**Date:** 2026-05-25
**Owner:** Jay Feng (jayfeng0625@gmail.com)
**Workspace:** `bonai-dev`
**Status:** Approved through brainstorming; ready for implementation planning.

---

## 1. Goal

Tailor the 14 engineering and productivity skills inherited from `mattpocock/skills` into a personal, ambiguity-free set, packaged as **two versioned tessl tiles** under the `bonai-dev` workspace. The set is intended to **replace** the `superpowers` skill plugin over time, so each skill must stand on its own with no superpowers fallback.

## 2. Foundational decisions

| Decision | Choice | Rationale |
|---|---|---|
| Workspace | `bonai-dev` | Matches existing `tessl.json` |
| Packaging | Two tiles: `bonai-dev/engineering-skills`, `bonai-dev/productivity-skills` | Coarser versioning, simpler manifests than 14 per-skill tiles |
| Versioning | Calver (`2026.05.0`), private | Continuously-evolving personal set; no public commitment yet |
| Customization depth | Medium — keep Matt's names, rewrite ambiguous sections | Lowest churn; names are already outcome-shaped |
| Tech stack posture | Language-agnostic | User works across TS/Node + Kotlin/JVM; skills should not assume |
| Issue tracker | Notion via Notion MCP | User's actual workflow surface |
| Superpowers relationship | Independent — no references | Bonai is intended to replace superpowers |
| Cadence | Stage 1 (5 skills) → Stage 2 (rest) | Validate Notion+commands contract before scaling |

## 3. Bucket reshuffle (target end state, after Stage 2)

`/handoff` moves from **productivity** to **engineering** because it requires Notion primitives (creating a page in the Handoffs DB). This keeps productivity completely independent of the tracker-primitives layer.

**Engineering tile (11 skills, target state)**
`setup-bonai-skills`, `tdd`, `diagnose`, `grill-with-docs`, `prototype`, `triage`, `to-issues`, `to-prd`, `improve-codebase-architecture`, `zoom-out`, `handoff`

**Productivity tile (3 skills, target state)**
`caveman`, `grill-me`, `write-a-skill`

Per the staged cadence (§7), Stage 1 publishes only the engineering tile with **5 skills in its manifest**. The remaining engineering skills + the productivity tile are added in Stage 2.

## 4. The contract: how skills talk to Notion

### 4.1 Layers

```
Skill body (abstract verbs)
        │
        ▼
tracker-primitives/notion.md  ← MCP recipes (shipped with the tile)
        │
        ▼
docs/agents/notion.md         ← Per-repo IDs & property mappings (written by /setup-bonai-skills)
        │
        ▼
Notion MCP tool calls         ← Concrete invocations
```

Skills only know **abstract verbs**. The tile-shipped `tracker-primitives/notion.md` translates each verb into MCP calls. The per-repo `docs/agents/notion.md` supplies the concrete IDs and property name mappings.

### 4.2 Controlled vocabulary of abstract verbs

| Verb | Used by |
|---|---|
| `transition state` | `/triage` |
| `post triage note` | `/triage` |
| `create issue page` | `/to-issues`, `/triage` |
| `create PRD page` | `/to-prd` |
| `create handoff page` | `/handoff` |
| `read glossary` | `/tdd`, `/diagnose`, `/grill-with-docs`, `/triage`, `/to-issues`, `/to-prd`, `/improve-codebase-architecture` |
| `write glossary entry` | `/grill-with-docs`, `/improve-codebase-architecture` |
| `read ADRs in area` | `/tdd`, `/diagnose`, `/grill-with-docs`, `/triage`, `/improve-codebase-architecture` |
| `create ADR` | `/grill-with-docs`, `/improve-codebase-architecture` |

Skills must not introduce new verbs without updating this list and the primitives files.

### 4.3 The 5 Notion databases

1. **Issues DB** — work items
2. **PRDs DB** — product requirements documents
3. **Handoffs DB** — cross-session handoff pages
4. **Domain Glossary DB** — replaces repo `CONTEXT.md`
5. **ADRs DB** — replaces repo `docs/adr/`

### 4.4 Per-repo configuration

`/setup-bonai-skills` writes:

- `CLAUDE.md` (or `AGENTS.md`): a minimal `## Agent skills` block pointing to the two config files
- `docs/agents/commands.md`: `test_command`, `lint_command`, `typecheck_command`, `build_command` — detected from `package.json` / `build.gradle` / `pyproject.toml`, confirmed with user, cached
- `docs/agents/notion.md`: workspace ID, 5 DB IDs, property→canonical-role mappings

**Example `docs/agents/notion.md`:**

```markdown
# Notion config

## Workspace
ID: <workspace-id>

## Databases
Issues DB:           <id>
PRDs DB:             <id>
Handoffs DB:         <id>
Domain Glossary DB:  <id>
ADRs DB:             <id>

## Issues DB properties
Status (status):
  needs-triage     → "needs-triage"
  needs-info       → "needs-info"
  ready-for-agent  → "ready-for-agent"
  ready-for-human  → "ready-for-human"
  wontfix          → "wontfix"
Category (select):
  bug              → "bug"
  enhancement      → "enhancement"
Blocked by: relation → Issues DB
```

### 4.5 .out-of-scope/ — stays in repo

The `.out-of-scope/*.md` knowledge base (used by `/triage` to avoid re-suggesting rejected enhancements) stays as repo files. It's an append-only set of repo-local rejections — flat and versioned with code.

### 4.6 Format files

`CONTEXT-FORMAT.md`, `ADR-FORMAT.md`, `AGENT-BRIEF.md`, `OUT-OF-SCOPE.md` become **page-body templates only** — what goes inside a Notion page body. DB schemas (properties) live in `docs/agents/notion.md`. The setup skill uses these as seed skeletons.

## 5. Repository layout

```
/Users/Home/Development/skills/
├── README.md                    # rebranded: bonai-dev, two-tile structure
├── tessl.json
├── .claude-plugin/plugin.json   # updated bucket distribution
├── tiles/
│   ├── engineering-skills/
│   │   └── tile.json            # scaffolded via mcp__tessl__new_tile
│   └── productivity-skills/
│       └── tile.json
├── skills/
│   ├── engineering/
│   │   ├── README.md
│   │   ├── tracker-primitives/  # NEW
│   │   │   ├── README.md
│   │   │   ├── notion.md
│   │   │   ├── gh.md
│   │   │   └── local.md
│   │   ├── setup-bonai-skills/  # renamed from setup-matt-pocock-skills
│   │   ├── tdd/
│   │   ├── diagnose/
│   │   ├── grill-with-docs/
│   │   ├── prototype/
│   │   ├── handoff/             # MOVED from productivity
│   │   ├── triage/              # Stage 2
│   │   ├── to-issues/           # Stage 2
│   │   ├── to-prd/              # Stage 2
│   │   ├── improve-codebase-architecture/  # Stage 2
│   │   └── zoom-out/            # Stage 2
│   └── productivity/
│       ├── README.md
│       ├── caveman/
│       ├── grill-me/
│       └── write-a-skill/
├── misc/         (unchanged)
├── personal/     (unchanged)
├── in-progress/  (unchanged)
└── deprecated/   (unchanged)
```

## 6. Per-skill customization plan

### 6.1 Stage 1 (v2026.05.0)

#### `setup-bonai-skills` (renamed from `setup-matt-pocock-skills`)

- Promote Notion from "Other → freeform" to first-class default.
- Drop GitHub/GitLab branches from the primary flow; keep them as references under `tracker-primitives/`.
- New section **Commands**: detect from `package.json` / `build.gradle` / `pyproject.toml` / `Cargo.toml`, confirm with user, write to `docs/agents/commands.md`.
- New section **Notion**: ask for 5 DB IDs + property mappings, write `docs/agents/notion.md`. Optionally offer to create missing DBs from seed schemas if user grants Notion MCP write access.
- Drop the Domain Docs file-layout question (CONTEXT.md and ADRs moved to Notion).
- Keep `disable-model-invocation: true` (user-invoked only).

#### `tdd`

- Replace "use the project's domain glossary" with abstract verb **`read glossary`**.
- Replace any test-runner-agnostic prose with explicit reference to `docs/agents/commands.md` (`test_command`, `typecheck_command`).
- Audit supporting files (`tests.md`, `mocking.md`, `deep-modules.md`, `interface-design.md`, `refactoring.md`) for vitest/jest/etc. leakage and neutralize.

#### `diagnose`

- Replace "domain glossary" / "check ADRs" with abstract verbs (`read glossary`, `read ADRs in area`).
- Phase 5 regression-test command → defer to `commands.md`.
- Bundle `scripts/hitl-loop.template.sh` referenced in Phase 1 (verify existence; create if missing).

#### `grill-with-docs`

- Replace inline writes to `CONTEXT.md` / `docs/adr/` with abstract verbs (`write glossary entry`, `create ADR`).
- Repurpose `CONTEXT-FORMAT.md` + `ADR-FORMAT.md` as Notion page-body templates.
- Drop the `CONTEXT-MAP.md` / multi-context branching (Notion DBs are flat; no per-context glossary).

#### `prototype`

- No skill-body changes (already validated as covering both static HTML mockups and interactive Opus prototypes).
- Verify `LOGIC.md` and `UI.md` supporting files exist.

### 6.2 Stage 2 (later)

#### `triage`

- Biggest rewrite. Replace "apply label" / "post comment" verbiage with abstract verbs (`transition state`, `post triage note`).
- Strip `/setup-matt-pocock-skills` reference → `/setup-bonai-skills`.
- Audit `AGENT-BRIEF.md` + `OUT-OF-SCOPE.md` — keep as page-body templates.
- Keep `.out-of-scope/` as repo files.

#### `to-issues`

- Swap "publish to issue tracker" → abstract verb `create issue page`.
- Dependency relations → Notion `Blocked by` relation property.

#### `to-prd`

- Swap target → `create PRD page` in PRDs DB.
- Stays no-interview (synthesizes existing context).

#### `improve-codebase-architecture`

- Abstract verbs for glossary/ADR reads/writes.
- HTML report unchanged (already self-contained, written to `$TMPDIR`).
- Audit `LANGUAGE.md`, `HTML-REPORT.md`, `INTERFACE-DESIGN.md`.
- Fix cross-skill refs to `../grill-with-docs/CONTEXT-FORMAT.md` (works inside one tile).

#### `zoom-out`

- Start as a 1-liner skill with supporting refs (modules map, callers index).
- Evolution path toward a full workflow (Agent(Explore)-driven mapping).

#### `handoff` (moved to engineering)

- Fixed-template Notion page in Handoffs DB.
- Sections: **Goal / What's done / Open questions / Suggested skills / Key files / Sensitive-info note**.
- Abstract verb: `create handoff page`.

#### `caveman` (productivity)

- No changes.

#### `grill-me` (productivity)

- Scope explicitly: **non-code grilling** — design/strategy/plans/talks with no codebase to read against.
- Make the non-overlap with `/grill-with-docs` explicit in the body.

#### `write-a-skill` (productivity)

- Stays tile-agnostic — produces a skill folder, not a tessl manifest entry.
- Audit for outdated guidance; align with bonai SKILL.md conventions.

### 6.3 Cross-cutting hygiene

- Verify every referenced supporting file exists in each skill folder.
- Strip every `/setup-matt-pocock-skills` reference → `/setup-bonai-skills`.
- Strip any GitHub-first phrasing in skill bodies; replace with abstract verbs.
- Rewrite top-level `README.md` (bonai branding, two-tile structure, Notion-first defaults).
- Update `.claude-plugin/plugin.json` for new bucket distribution (handoff moves to engineering).
- Update each bucket's `README.md` to match the new skill list.

## 7. Tessl publish sequence

### 7.1 Stage 1 (engineering tile only — v2026.05.0)

1. **Scaffold the engineering tile.** `mcp__tessl__new_tile` for `bonai-dev/engineering-skills` (private). Productivity tile is not scaffolded in Stage 1.
2. **Reshuffle.** Move `skills/productivity/handoff/` → `skills/engineering/handoff/`. Update `.claude-plugin/plugin.json` + bucket READMEs. The handoff folder is moved but its body is not customized in Stage 1.
3. **Land `tracker-primitives/`.** Create `notion.md`, `gh.md`, `local.md` with abstract-verb recipes (full set, even though Stage 1 skills only exercise a subset of verbs — establishes the pattern).
4. **Customize the 5 Stage 1 skills** per Section 6.1: `setup-bonai-skills`, `tdd`, `diagnose`, `grill-with-docs`, `prototype`.
5. **Audit supporting files** for each Stage 1 skill.
6. **Local validation.** Install engineering tile into a scratch repo via `tessl install`; run `/setup-bonai-skills` against a test Notion workspace; run `/tdd` and `/diagnose` against a sample project.
7. **Publish engineering tile at v2026.05.0.** Manifest includes only the 5 customized Stage 1 skills. Remaining engineering skills present in the repo are excluded from the manifest until Stage 2.

### 7.2 Stage 2 (later — v2026.XX.0)

- Customize the 6 remaining engineering skills.
- Add them to the engineering tile manifest; publish engineering tile at v2026.XX.0.
- Scaffold the productivity tile via `mcp__tessl__new_tile`.
- Customize the 3 productivity skills.
- Publish productivity tile at v2026.XX.0 (XX = publish month; same calver as engineering bump).

## 8. Acceptance criteria

Stage 1 is done when:

- [ ] `mcp__tessl__status` shows `bonai-dev/engineering-skills` in sync at `2026.05.0`.
- [ ] `tessl install bonai-dev/engineering-skills@2026.05.0` in a scratch repo succeeds.
- [ ] `/setup-bonai-skills` in a scratch repo produces a valid `docs/agents/commands.md` and `docs/agents/notion.md`.
- [ ] `/tdd` in the scratch repo runs without referring to vitest/jest by name and uses commands from `docs/agents/commands.md`.
- [ ] `/diagnose` Phase 5 uses `commands.md` for the regression-test command.
- [ ] `/grill-with-docs` writes glossary entries to the Domain Glossary DB and ADRs to the ADRs DB (not to repo files).
- [ ] `/prototype` runs unchanged.
- [ ] Every Stage 1 customized skill body contains zero references to `setup-matt-pocock-skills`, `matt-pocock`, `gh issue`, or specific test runners by name.
- [ ] The engineering tile manifest at v2026.05.0 contains exactly the 5 Stage 1 skills — uncustomized engineering skills in the repo are excluded from the manifest.

## 9. Open items deferred to implementation

- Exact `tile.json` schema — defer to whatever `mcp__tessl__new_tile` scaffolds.
- Whether `/setup-bonai-skills` should **create** Notion DBs from seed schemas, or only accept existing IDs (lean toward offering both: detect-or-create on first run).
- Whether the engineering tile bundles `gh.md` and `local.md` primitives in Stage 1 even though Stage 1 skills don't use them (lean toward yes — establishes the pattern).

## 10. Out of scope

- Skills under `misc/`, `personal/`, `in-progress/`, `deprecated/` — these stay as-is.
- Public-facing tessl publishing — tiles remain private throughout both stages.
- A separate `bonai-dev/tracker-primitives` tile — keeping primitives inside the engineering tile is simpler at this scale.
- Migration tooling to move existing repo `CONTEXT.md` / `docs/adr/` content into Notion DBs — manual one-time activity per repo.
