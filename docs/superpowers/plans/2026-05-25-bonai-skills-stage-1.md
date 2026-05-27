# Bonai Skills Stage 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship `bonai-dev/engineering-skills@2026.05.0` — a 5-skill, Notion-first, language-agnostic tile that replaces five Matt-Pocock-named skills with bonai-branded equivalents and lands the abstract-verb tracker contract.

**Architecture:** Three-layer contract — skill bodies use abstract verbs, tile-shipped `tracker-primitives/` translates verbs to MCP/CLI calls, per-repo `docs/agents/notion.md` + `docs/agents/commands.md` hold concrete IDs and commands. Stage 1 lands the engineering tile only; productivity tile and the 6 remaining engineering skills wait for Stage 2.

**Tech Stack:** Markdown skills, Tessl MCP (`mcp__tessl__new_tile`, `mcp__tessl__status`, `mcp__tessl__install`), Notion MCP recipes, git for renames.

**Source spec:** `docs/superpowers/specs/2026-05-25-bonai-skills-customization-design.md`

**Scope note:** This plan covers Stage 1 only (5 skills + tracker-primitives + reshuffle + publish). Stage 2 (the 6 remaining engineering skills + productivity tile) is a separate plan written later.

---

## Task index

| # | Task | Key files | Notes |
|---|---|---|---|
| 1 | Scaffold the engineering tile | `tiles/engineering-skills/tile.json` | via `mcp__tessl__new_tile` |
| 2 | Move handoff to engineering bucket | `skills/engineering/handoff/`, `.claude-plugin/plugin.json` | Folder move only; body untouched |
| 3 | tracker-primitives README + verb index | `skills/engineering/tracker-primitives/README.md` | Controlled vocabulary of 9 verbs |
| 4 | tracker-primitives Notion recipes | `skills/engineering/tracker-primitives/notion.md` | Primary backend, all 9 verbs |
| 5 | tracker-primitives gh + local recipes | `skills/engineering/tracker-primitives/{gh,local}.md` | Reference backends |
| 6 | Rename setup skill, rewrite SKILL.md | `skills/engineering/setup-bonai-skills/SKILL.md` | Repo-wide matt-pocock → bonai pass |
| 7 | setup-bonai-skills seed templates | `skills/engineering/setup-bonai-skills/{commands,notion}.template.md` | Includes DB seed schemas |
| 8 | Customize tdd | `skills/engineering/tdd/SKILL.md`, `tests.md` | Commands section; runner-agnostic; no tracker-primitives load |
| 9 | Customize diagnose | `skills/engineering/diagnose/SKILL.md` | Phase 5 defers to `commands.md`; no tracker-primitives load |
| 10 | Rewrite grill-with-docs | `skills/engineering/grill-with-docs/{SKILL,CONTEXT-FORMAT,ADR-FORMAT}.md` | Page-body templates; drop multi-context |
| 11 | Verify prototype | `skills/engineering/prototype/` | No body changes |
| 12 | Cross-cutting hygiene | `README.md`, `.claude-plugin/plugin.json`, bucket READMEs | Unified hygiene grep |
| 13 | Populate tile manifest | `tiles/engineering-skills/tile.json` | Exactly the 5 Stage 1 skills |
| 14 | Local validation in scratch repo | (no repo file changes) | **User-driven** — Jay runs interactively |
| 15 | Publish the tile at v2026.05.0 | `tessl tile publish` | **User-driven** — one-way action |

---

## File Structure

**New files:**
- `tiles/engineering-skills/tile.json` — scaffolded by `mcp__tessl__new_tile`, edited to list 5 Stage 1 skills
- `skills/engineering/tracker-primitives/README.md` — index of abstract verbs → backend recipe files
- `skills/engineering/tracker-primitives/notion.md` — Notion MCP recipes for all 9 verbs
- `skills/engineering/tracker-primitives/gh.md` — GitHub `gh` CLI recipes (reference backend)
- `skills/engineering/tracker-primitives/local.md` — local-markdown recipes (reference backend)
- `skills/engineering/setup-bonai-skills/commands.template.md` — seed template for per-repo `docs/agents/commands.md`
- `skills/engineering/setup-bonai-skills/notion.template.md` — seed template for per-repo `docs/agents/notion.md`

**Renamed (git mv to preserve history):**
- `skills/engineering/setup-matt-pocock-skills/` → `skills/engineering/setup-bonai-skills/`
- `skills/productivity/handoff/` → `skills/engineering/handoff/`

**Deleted (after rename):**
- `skills/engineering/setup-bonai-skills/issue-tracker-github.md`
- `skills/engineering/setup-bonai-skills/issue-tracker-gitlab.md`
- `skills/engineering/setup-bonai-skills/issue-tracker-local.md`
- `skills/engineering/setup-bonai-skills/triage-labels.md`
- `skills/engineering/setup-bonai-skills/domain.md`

**Rewritten in place:**
- `skills/engineering/setup-bonai-skills/SKILL.md` — Notion-first body
- `skills/engineering/tdd/SKILL.md` — abstract `read glossary` verb, `commands.md` references
- `skills/engineering/tdd/tests.md` — remove jest mention
- `skills/engineering/diagnose/SKILL.md` — abstract verbs, `commands.md` for Phase 5
- `skills/engineering/grill-with-docs/SKILL.md` — abstract verbs, drop multi-context branching
- `skills/engineering/grill-with-docs/CONTEXT-FORMAT.md` — Notion page-body template
- `skills/engineering/grill-with-docs/ADR-FORMAT.md` — Notion page-body template
- `README.md` — bonai branding, two-tile structure, Notion-first defaults
- `.claude-plugin/plugin.json` — rename setup skill, move handoff to engineering, rename top-level `name` to `bonai-skills`. Keeps all 14 skills (CLAUDE.md requires every engineering/productivity/misc skill to be listed here; the Stage-1 5-skill scope only applies to the tile manifest, not the local plugin manifest).
- `skills/engineering/README.md` — new skill list (handoff added, setup renamed; uncustomized skills tagged "Stage 2 — not in tile manifest")
- `skills/productivity/README.md` — remove handoff entry

**Untouched (Stage 2 work):**
- `skills/engineering/triage/`, `to-issues/`, `to-prd/`, `improve-codebase-architecture/`, `zoom-out/`
- `skills/productivity/caveman/`, `grill-me/`, `write-a-skill/`
- `tessl.json` (already `bonai-dev/skills`)

---

## Task 1: Scaffold the engineering tile

**Files:**
- Create: `tiles/engineering-skills/tile.json` (via MCP tool)

- [ ] **Step 1: Confirm tessl auth + workspace**

Run: `mcp__tessl__status`
Expected: shows workspace `bonai-dev` authenticated. If not, run `mcp__tessl__login` and complete the browser flow before proceeding.

- [ ] **Step 2: Check whether the tile already exists**

Call `mcp__tessl__search` (or read `mcp__tessl__status` output) for `bonai-dev/engineering-skills`. Two outcomes:

- **Tile does not exist** → proceed to Step 3 to scaffold it.
- **Tile already exists** (e.g. from a prior aborted Stage 1 run) → skip Step 3. If a local `tiles/engineering-skills/tile.json` already exists too, re-use it and jump to Step 5. If only the remote tile exists, ask the user whether to delete-and-recreate or pull the existing tile down — do not silently overwrite the remote.

- [ ] **Step 3: Scaffold the engineering tile**

Call: `mcp__tessl__new_tile` with workspace `bonai-dev`, name `engineering-skills`, visibility `private`, initial version `2026.05.0`.

If the tool requires additional fields not listed above (description, license, etc.), use:
- description: `Engineering skills for daily code work — Notion-first, language-agnostic`
- license: leave default

Expected: file appears at `tiles/engineering-skills/tile.json`.

- [ ] **Step 4: Read the scaffolded tile.json and capture its schema**

Run: `cat tiles/engineering-skills/tile.json`
Capture the field names the scaffold produced (especially how it lists skills — array of paths, array of objects, etc.). All later steps that touch this file must match the actual schema, not the assumed shape.

- [ ] **Step 5: Commit the scaffold as-is**

```bash
git add tiles/engineering-skills/tile.json
git commit -m "chore: scaffold bonai-dev/engineering-skills tile at v2026.05.0"
```

Note: the manifest will be populated in Task 13 once all 5 Stage 1 skills are in place.

---

## Task 2: Reshuffle — move handoff to engineering bucket

**Files:**
- Move: `skills/productivity/handoff/` → `skills/engineering/handoff/`
- Modify: `.claude-plugin/plugin.json`
- Modify: `skills/productivity/README.md`
- Modify: `skills/engineering/README.md`

Handoff's body is **not customized in Stage 1** (that waits for Stage 2). This task only moves the folder so the bucket structure is right.

- [ ] **Step 1: Move the handoff folder**

```bash
git mv skills/productivity/handoff skills/engineering/handoff
```

Verify:
```bash
ls skills/engineering/handoff/
ls skills/productivity/ | grep -v handoff
```
Expected: `SKILL.md` present in the new location; old location no longer lists `handoff`.

- [ ] **Step 2: Remove handoff from `productivity/README.md`**

Open `skills/productivity/README.md` and delete this line:

```
- **[handoff](./handoff/SKILL.md)** — Compact the current conversation into a handoff document so another agent can continue the work.
```

- [ ] **Step 3: Add handoff to `engineering/README.md`**

The bucket README is rewritten in Task 9 along with the rest of the cross-cutting hygiene. For now, append this line at the end of `skills/engineering/README.md`:

```
- **[handoff](./handoff/SKILL.md)** — Compact the current conversation into a handoff document so another agent can continue the work.
```

(Task 9 will rewrite the full file; this interim edit keeps the README accurate between tasks.)

- [ ] **Step 4: Update `.claude-plugin/plugin.json`**

Open `.claude-plugin/plugin.json`. Move the handoff entry from the productivity section to engineering:

Find:
```
    "./skills/productivity/handoff",
```
Delete it.

In the engineering list, after `"./skills/engineering/prototype"`, add:
```
    "./skills/engineering/handoff",
```

Also rename the manifest name from `mattpocock-skills` to `bonai-skills`:
```
  "name": "bonai-skills",
```

(The full pruning of the engineering list to Stage 1 only happens in Task 9. This step only handles the handoff move + name change.)

- [ ] **Step 5: Verify**

Run:
```bash
ls skills/engineering/handoff/SKILL.md
test ! -d skills/productivity/handoff && echo OK
grep -c "handoff" .claude-plugin/plugin.json
```
Expected: SKILL.md exists, old dir gone, exactly 1 handoff reference in plugin.json (under engineering).

- [ ] **Step 6: Commit**

```bash
git add skills/productivity/handoff skills/engineering/handoff skills/productivity/README.md skills/engineering/README.md .claude-plugin/plugin.json
git commit -m "refactor: move handoff to engineering bucket"
```

---

## Task 3: Create tracker-primitives/ — README + index

**Files:**
- Create: `skills/engineering/tracker-primitives/README.md`

- [ ] **Step 1: Write the README**

Create `skills/engineering/tracker-primitives/README.md` with exactly this content:

````markdown
# Tracker primitives

Engineering skills speak in **abstract verbs**. This folder translates each verb into concrete tool calls for a specific backend.

A skill says: "create issue page with these fields."
The primitives file says: "for Notion, that's `mcp__notion__notion-create-pages` against the Issues DB; for GitHub, that's `gh issue create`; for local, that's a markdown file under `.scratch/`."

Per-repo IDs (database IDs, label strings, file paths) live in `docs/agents/notion.md` or equivalent, written by `/setup-bonai-skills`.

## Controlled vocabulary

Skills may only use these verbs. Adding a new verb requires a recipe in every backend file in this folder **and** an update to the design spec.

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

## Backends

- [`notion.md`](./notion.md) — primary backend, uses the Notion MCP
- [`gh.md`](./gh.md) — GitHub via `gh` CLI (reference; not Stage 1 default)
- [`local.md`](./local.md) — local markdown files (reference; not Stage 1 default)

## Choosing a backend

`/setup-bonai-skills` picks one backend per repo and writes the per-repo config. Skills then look up the chosen backend from `CLAUDE.md` / `AGENTS.md` and load the matching recipe file from this folder.

## Read verbs without loading primitives

Skills that *only* read (e.g. `/tdd`, `/diagnose`) consume `read glossary` and `read ADRs in area` via the **Domain language** entry in CLAUDE.md / AGENTS.md's `## Agent skills` section, rather than loading this folder. The entry names the source IDs/paths directly so a read happens in one MCP call without the verb-translation layer.

The read verbs stay in the controlled vocabulary above because skills that *also write* (`/grill-with-docs`, plus Stage 2 skills like `/triage`, `/to-issues`, `/improve-codebase-architecture`) keep the read+write pair in the same backend file for symmetry — they already pay the cost of loading this folder for their writes.
````

- [ ] **Step 2: Commit the index**

```bash
git add skills/engineering/tracker-primitives/README.md
git commit -m "feat: add tracker-primitives index and controlled verb vocabulary"
```

---

## Task 4: tracker-primitives/notion.md — primary backend

**Files:**
- Create: `skills/engineering/tracker-primitives/notion.md`

- [ ] **Step 1: Write the Notion recipes**

Create `skills/engineering/tracker-primitives/notion.md` with this content:

````markdown
# Notion primitives

Each section maps one abstract verb to its Notion MCP call. All IDs (workspace, databases, property names) come from `docs/agents/notion.md` in the consuming repo. Never hardcode an ID here.

## Lookup

Before any verb, read `docs/agents/notion.md` once at the start of the conversation. Cache the DB IDs and property mappings. If the file is missing, stop and ask the user to run `/setup-bonai-skills`.

## Verbs

### `transition state`

Used by `/triage` to move an issue between states (needs-triage → ready-for-agent, etc).

Tool: `mcp__notion__notion-update-page`
- `page_id`: the issue page ID
- Property to update: the **Status** property name from `docs/agents/notion.md` (canonical role → string mapping)
- Value: the mapped string for the target role (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`)

### `post triage note`

Used by `/triage` to add a comment explaining why a state transition happened.

Tool: `mcp__notion__notion-create-comment`
- Target: the issue page ID
- Body: the triage note in markdown

### `create issue page`

Used by `/to-issues` and `/triage` to create a new issue in the Issues DB.

Tool: `mcp__notion__notion-create-pages`
- Parent: Issues DB ID from `docs/agents/notion.md`
- Properties: title (required); Status property set to `needs-triage` mapping; Category if `bug` / `enhancement` is known
- Body: rendered from the issue template (see consuming skill for the template)

For dependencies, set the **Blocked by** relation property to the page IDs of blocking issues.

### `create PRD page`

Used by `/to-prd` to create a new PRD in the PRDs DB.

Tool: `mcp__notion__notion-create-pages`
- Parent: PRDs DB ID
- Properties: title (required); other properties per the PRDs DB schema in `docs/agents/notion.md`
- Body: rendered PRD content

### `create handoff page`

Used by `/handoff` to create a handoff page in the Handoffs DB.

Tool: `mcp__notion__notion-create-pages`
- Parent: Handoffs DB ID
- Properties: title (required); date defaults to today
- Body: handoff document with the standard sections (Goal / What's done / Open questions / Suggested skills / Key files / Sensitive-info note)

### `read glossary`

Used by skills that need the domain language to ground their reasoning.

Tool: `mcp__notion__notion-fetch` on the Domain Glossary DB ID
- Fetch all pages in the DB
- Treat each page as one glossary entry (page title = term, page body = definition + aliases)

If the DB returns >50 pages, page through. Cache the result for the conversation.

### `write glossary entry`

Used by `/grill-with-docs` and `/improve-codebase-architecture` when a new term gets resolved during a session.

Tool: `mcp__notion__notion-create-pages`
- Parent: Domain Glossary DB ID
- Title: the canonical term
- Body: uses the page-body template from `skills/engineering/grill-with-docs/CONTEXT-FORMAT.md`

If a page with the same title already exists, use `mcp__notion__notion-update-page` instead of creating a duplicate.

### `read ADRs in area`

Used by skills that need to respect past architectural decisions before suggesting changes.

Tool: `mcp__notion__notion-fetch` on the ADRs DB ID
- Filter to ADRs tagged or filed under the relevant area (the area-tagging property is recorded in `docs/agents/notion.md`)
- Read the page bodies

### `create ADR`

Used by `/grill-with-docs` and `/improve-codebase-architecture` when a hard-to-reverse decision is made during a session.

Tool: `mcp__notion__notion-create-pages`
- Parent: ADRs DB ID
- Title: short decision title
- Body: uses the page-body template from `skills/engineering/grill-with-docs/ADR-FORMAT.md`
- Properties: set the area tag if `docs/agents/notion.md` defines one

## Error handling

If a Notion MCP call fails (auth, missing DB, schema mismatch), stop the verb invocation and tell the user. Do not silently retry or fall back to another backend.
````

- [ ] **Step 2: Verify the file mentions all 9 verbs**

Run:
```bash
for verb in "transition state" "post triage note" "create issue page" "create PRD page" "create handoff page" "read glossary" "write glossary entry" "read ADRs in area" "create ADR"; do
  grep -q "### \`$verb\`" skills/engineering/tracker-primitives/notion.md && echo "OK: $verb" || echo "MISSING: $verb"
done
```
Expected: 9 `OK` lines, no `MISSING` lines.

- [ ] **Step 3: Commit**

```bash
git add skills/engineering/tracker-primitives/notion.md
git commit -m "feat: add Notion recipes for all 9 abstract tracker verbs"
```

---

## Task 5: tracker-primitives/gh.md + local.md — reference backends

**Files:**
- Create: `skills/engineering/tracker-primitives/gh.md`
- Create: `skills/engineering/tracker-primitives/local.md`

These are reference backends — Stage 1 skills do not exercise them, but the contract requires every verb has a recipe everywhere.

- [ ] **Step 1: Write gh.md**

Create `skills/engineering/tracker-primitives/gh.md` with this content:

````markdown
# GitHub (`gh` CLI) primitives

Reference backend. Per-repo config lives in `docs/agents/github.md` (label mapping, repo slug) — written by `/setup-bonai-skills` when the user picks GitHub as the tracker.

## Verbs

### `transition state`

Tool: `gh issue edit <number> --add-label <mapped-label> --remove-label <old-mapped-label>`
- Look up the canonical role → label string mapping in `docs/agents/github.md`.

### `post triage note`

Tool: `gh issue comment <number> --body "<note>"`

### `create issue page`

Tool: `gh issue create --title "<title>" --body "<body>" --label "<status-label>"`
- If the issue has dependencies, append "Blocked by #N" lines to the body — gh has no native dependency relation.

### `create PRD page`

Tool: `gh issue create --title "<title>" --body "<body>" --label "prd"`
- Or, if `docs/agents/github.md` configures a separate PRD repo, target that with `--repo`.

### `create handoff page`

Tool: GitHub does not have a natural handoff store. Use a `gh gist create` with the handoff body, or write to a `.handoffs/` folder in the repo per `docs/agents/github.md`.

### `read glossary`

GitHub has no glossary DB. Read `CONTEXT.md` from the repo root (fallback to repo files when GitHub is the tracker).

### `write glossary entry`

Append to `CONTEXT.md` using the page-body template from `skills/engineering/grill-with-docs/CONTEXT-FORMAT.md`.

### `read ADRs in area`

Read files from `docs/adr/` in the repo.

### `create ADR`

Write a new file under `docs/adr/NNNN-<slug>.md` using the page-body template from `skills/engineering/grill-with-docs/ADR-FORMAT.md`. Numbering: scan existing files, take max+1.

## Notes

This backend is shipped for completeness. `/setup-bonai-skills` does not offer GitHub as a default in Stage 1 — Notion is the primary path.
````

- [ ] **Step 2: Write local.md**

Create `skills/engineering/tracker-primitives/local.md` with this content:

````markdown
# Local markdown primitives

Reference backend. All "tracker" state lives in the repo as markdown files. Per-repo config lives in `docs/agents/local.md` (folder paths) — written by `/setup-bonai-skills` when the user picks local.

## Layout

```
.scratch/
  issues/<id>-<slug>.md       ← one file per issue
  prds/<id>-<slug>.md         ← one file per PRD
  handoffs/<date>-<slug>.md   ← one file per handoff
CONTEXT.md                    ← glossary
docs/adr/NNNN-<slug>.md       ← ADRs
```

## Verbs

### `transition state`

Edit the issue file's frontmatter `status:` field to the mapped role string.

### `post triage note`

Append a `## Triage note (<date>)` section to the bottom of the issue file.

### `create issue page`

Create `.scratch/issues/<next-id>-<slug>.md` with frontmatter (title, status, category, blocked_by) and the rendered body. `next-id` = max existing id + 1.

### `create PRD page`

Create `.scratch/prds/<next-id>-<slug>.md` with the PRD body.

### `create handoff page`

Create `.scratch/handoffs/<YYYY-MM-DD>-<slug>.md` with the handoff sections.

### `read glossary`

Read `CONTEXT.md` from the repo root.

### `write glossary entry`

Append to `CONTEXT.md` using the page-body template from `skills/engineering/grill-with-docs/CONTEXT-FORMAT.md`.

### `read ADRs in area`

Read files from `docs/adr/` matching the area folder convention if `docs/agents/local.md` defines one; otherwise read all.

### `create ADR`

Write `docs/adr/NNNN-<slug>.md` using the ADR page-body template. NNNN = max existing + 1.

## Notes

Reference backend; not the Stage 1 default. Useful for solo repos with no Notion workspace.
````

- [ ] **Step 3: Verify each file covers all 9 verbs**

```bash
for f in skills/engineering/tracker-primitives/gh.md skills/engineering/tracker-primitives/local.md; do
  echo "=== $f ==="
  for verb in "transition state" "post triage note" "create issue page" "create PRD page" "create handoff page" "read glossary" "write glossary entry" "read ADRs in area" "create ADR"; do
    grep -q "### \`$verb\`" "$f" && echo "OK: $verb" || echo "MISSING: $verb"
  done
done
```
Expected: 9 `OK` lines per file.

- [ ] **Step 4: Commit**

```bash
git add skills/engineering/tracker-primitives/gh.md skills/engineering/tracker-primitives/local.md
git commit -m "feat: add gh and local reference recipes for all tracker verbs"
```

---

## Task 6: Rename setup skill folder + rewrite SKILL.md

**Files:**
- Move: `skills/engineering/setup-matt-pocock-skills/` → `skills/engineering/setup-bonai-skills/`
- Delete: `skills/engineering/setup-bonai-skills/issue-tracker-github.md`, `issue-tracker-gitlab.md`, `issue-tracker-local.md`, `triage-labels.md`, `domain.md`
- Rewrite: `skills/engineering/setup-bonai-skills/SKILL.md`

- [ ] **Step 1: Rename the folder**

```bash
git mv skills/engineering/setup-matt-pocock-skills skills/engineering/setup-bonai-skills
```

Verify:
```bash
ls skills/engineering/setup-bonai-skills/
test ! -d skills/engineering/setup-matt-pocock-skills && echo OK
```

- [ ] **Step 2: Delete the obsolete supporting files**

```bash
git rm skills/engineering/setup-bonai-skills/issue-tracker-github.md \
       skills/engineering/setup-bonai-skills/issue-tracker-gitlab.md \
       skills/engineering/setup-bonai-skills/issue-tracker-local.md \
       skills/engineering/setup-bonai-skills/triage-labels.md \
       skills/engineering/setup-bonai-skills/domain.md
```

Verify:
```bash
ls skills/engineering/setup-bonai-skills/
```
Expected: only `SKILL.md` remains (templates land in Task 7).

- [ ] **Step 3: Rewrite SKILL.md**

Overwrite `skills/engineering/setup-bonai-skills/SKILL.md` with this full content:

````markdown
---
name: setup-bonai-skills
description: Sets up an `## Agent skills` block in AGENTS.md/CLAUDE.md and `docs/agents/` so the engineering skills know this repo's per-language commands and Notion database IDs. Run before first use of `tdd`, `diagnose`, `grill-with-docs`, `prototype`, or any other engineering skill that reads from `docs/agents/`.
disable-model-invocation: true
---

# Setup Bonai Skills

Scaffold the per-repo configuration that the engineering skills assume:

- **Commands** — the canonical shell commands for running tests, linting, type-checking, and building this repo. Skills never name a test runner directly; they read these.
- **Notion** — workspace ID, the 5 database IDs (Issues, PRDs, Handoffs, Domain Glossary, ADRs), and the property → canonical-role mappings so skills can use abstract verbs.

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `AGENTS.md` and `CLAUDE.md` at the repo root — does either exist? Is there already an `## Agent skills` section?
- `docs/agents/` — does this skill's prior output already exist? If `commands.md` or `notion.md` is present, treat it as the user's authoritative version and offer to edit it rather than overwriting.
- Project manifest files for inference hints only: `package.json`, `pyproject.toml`, `Cargo.toml`, `build.gradle(.kts)`, `Makefile`. Surface candidate commands from `scripts` blocks, but the user's answer is authoritative — never silently detect.

### 2. Walk the user through Commands

Use `AskUserQuestion` to ask about each of the four canonical commands in sequence. For each, present any inferred candidates as the first option labelled "(Inferred from <file>)".

For each command, ask one question. Example for `test_command`:

> What command runs the test suite for this repo? Skills like `/tdd` and `/diagnose` will use this verbatim — it should be the single command that runs all tests from a clean shell.

Repeat for `lint_command`, `typecheck_command`, `build_command`. If any of the four doesn't apply (e.g. a TS-only repo with no separate build step), accept "n/a" — skills will skip that command when it's blank.

### 3. Walk the user through Notion

Notion is the default backend in Stage 1; the interactive flow below is Notion-specific. If the user does not use Notion, point them at the reference recipes in `../tracker-primitives/gh.md` or `../tracker-primitives/local.md` and let them hand-author `docs/agents/<backend>.md` from those files — the engineering tile still works, just without the interactive setup for that backend.

For Notion users, ask in sequence:

1. **Workspace ID.** "Paste the workspace ID for the Notion workspace you'll use for this repo."
2. **The 5 database IDs.** One question per DB: Issues DB, PRDs DB, Handoffs DB, Domain Glossary DB, ADRs DB. For each, ask: "Paste the database ID, or say 'create' and I will create it from a seed schema." If the user says 'create', call `mcp__notion__notion-create-database` against the workspace using the matching DB's property schema from the **`## DB seed schemas`** section of [`notion.template.md`](./notion.template.md). If the create call fails (no MCP write permission, auth error), stop and tell the user — they need to grant Notion MCP write access or create the DB manually and re-run, in which case prompt for the ID instead.
3. **Property mappings for the Issues DB.** Ask the user to confirm or override the canonical Status mappings: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Default: each role's string equals its name. Ask the user to confirm or override the Category mappings: `bug`, `enhancement`. Default: each maps to its own name. Ask whether the DB has a `Blocked by` relation property; if so, capture its exact name.

### 4. Confirm and write

Show the user a draft of:

- The `## Agent skills` block to add to whichever of `CLAUDE.md` / `AGENTS.md` is being edited (see step 5 for selection rules). The block includes a **Domain language** entry pointing read-only consumers (`/tdd`, `/diagnose`) directly at the Glossary + ADRs DBs without going through `tracker-primitives/`.
- The contents of `docs/agents/commands.md` (use [`commands.template.md`](./commands.template.md) as the seed)
- The contents of `docs/agents/notion.md` (use [`notion.template.md`](./notion.template.md) as the seed)

Let them edit before writing.

### 5. Write

**Pick the file to edit:**

- If `CLAUDE.md` exists, edit it.
- Else if `AGENTS.md` exists, edit it.
- If neither exists, ask the user which one to create — don't pick for them.

Never create `AGENTS.md` when `CLAUDE.md` already exists (or vice versa) — always edit the one already there.

If an `## Agent skills` block already exists, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

The block:

```markdown
## Agent skills

### Commands

Repo-wide commands for testing, linting, type-checking, and building. See `docs/agents/commands.md`.

### Notion

Workspace, database IDs, and property mappings used by tracker-primitives. See `docs/agents/notion.md`.

### Domain language

Domain glossary and ADRs live in the Notion workspace — see `docs/agents/notion.md` for the Domain Glossary DB ID and ADRs DB ID. To consult them, use `mcp__notion__notion-fetch` on the respective DB ID. This is the read path for skills that ground in domain language without otherwise needing `tracker-primitives/` (e.g. `/tdd`, `/diagnose`).
```

If the user picked a non-Notion backend (gh / local), substitute the matching pointer instead — for gh: "Domain glossary lives in `CONTEXT.md` at the repo root; ADRs in `docs/adr/`." For local: same convention. Stage 1's interactive flow is Notion-only; non-Notion repos hand-author this entry per the relevant `tracker-primitives/<backend>.md`.

Then write `docs/agents/commands.md` and `docs/agents/notion.md` using the templates in this skill folder.

### 6. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `docs/agents/*.md` directly later — re-running this skill is only necessary to switch backends or restart from scratch.
````

- [ ] **Step 4: Update plugin.json's setup path to the new folder name**

In `.claude-plugin/plugin.json`, replace:
```
    "./skills/engineering/setup-matt-pocock-skills",
```
With:
```
    "./skills/engineering/setup-bonai-skills",
```

(plugin.json gets a full rewrite in Task 12. This step only fixes the broken path so the manifest stays valid between commits.)

- [ ] **Step 5: Global rename — `/setup-matt-pocock-skills` → `/setup-bonai-skills` across the repo**

Spec §6.3 says strip **every** `/setup-matt-pocock-skills` reference. After Step 1, the folder no longer exists — any remaining references (in Stage 2 skill bodies, in-progress drafts, the engineering bucket README, etc.) point at a dead path. Fix them all in one pass.

First, list every offending file (the global scan):

```bash
grep -rln "setup-matt-pocock-skills\|matt-pocock\|mattpocock\|Matt Pocock" \
  --exclude-dir=.git --exclude-dir=node_modules \
  --exclude=LICENSE \
  /Users/Home/Development/skills/
```

Expected list (current snapshot — may differ if upstream changes happened):
- `skills/in-progress/review/SKILL.md`
- `skills/engineering/README.md` *(rewritten in Task 12 Step 3 — leave for now)*
- `skills/engineering/triage/SKILL.md`
- `skills/engineering/to-issues/SKILL.md`
- `skills/engineering/to-prd/SKILL.md`
- `CONTEXT.md` *(repo-root glossary — title "Matt Pocock Skills" + a `setup-matt-pocock-skills` reference)*
- `.out-of-scope/mainstream-issue-trackers-only.md` *(triage knowledge base — references old skill name)*
- `.out-of-scope/setup-skill-verify-mode.md` *(triage knowledge base — references old skill name in title + body)*
- `docs/adr/0001-explicit-setup-pointer-only-for-hard-dependencies.md` *(ADR body — title and §7 reference the old skill name; rename body content, filename stays as-is since the slug uses "setup-pointer" not "setup-matt-pocock")*
- `README.md` *(top-level — rewritten in Task 12 Step 1; leave for now)*

If `git status` shows an untracked `2026-05-25-bonai-skills-customization-design.md` at the repo root (stray duplicate of the canonical spec under `docs/superpowers/specs/`), delete it as part of this step — it should not exist:

```bash
test -f /Users/Home/Development/skills/2026-05-25-bonai-skills-customization-design.md && rm /Users/Home/Development/skills/2026-05-25-bonai-skills-customization-design.md
```

(`skills/engineering/setup-matt-pocock-skills/SKILL.md` should no longer exist after Step 1.)

For each file in the list **except** `skills/engineering/README.md` and the top-level `README.md` (both rewritten in Task 12), do an in-place replace:
- `/setup-matt-pocock-skills` → `/setup-bonai-skills` (slash-command form)
- `setup-matt-pocock-skills` → `setup-bonai-skills` (bare — folder/path refs)
- `Matt Pocock Skills` / `Matt Pocock skills` → `Bonai Skills` (repo title rebrand in `CONTEXT.md`)
- `matt-pocock` / `mattpocock` in plain prose → `bonai` (skill bodies, decision records — but never inside URLs to external resources like `skills.sh/mattpocock/skills`, which are upstream attribution and should be preserved or removed deliberately, not auto-replaced)

`LICENSE` and `docs/superpowers/specs/2026-05-25-bonai-skills-customization-design.md` are intentionally left alone:
- `LICENSE` — author attribution, not a code reference.
- The spec — historical record of the rename decision; keeps the "renamed from `setup-matt-pocock-skills`" mention as a deliberate spec artifact.

- [ ] **Step 6: Verify only the deferred files still contain Matt Pocock references**

```bash
grep -rlnE "matt[ -]?pocock|mattpocock|setup-matt-pocock-skills" \
  --exclude-dir=.git --exclude=LICENSE \
  /Users/Home/Development/skills/
```

Expected output set:
- `README.md` *(top-level — rewritten in Task 12 Step 1)*
- `skills/engineering/README.md` *(rewritten in Task 12 Step 3)*
- `docs/superpowers/specs/2026-05-25-bonai-skills-customization-design.md` *(spec historical record)*
- `docs/superpowers/plans/2026-05-25-bonai-skills-stage-1.md` *(this plan — historical record)*

Anything else in the output is a missed rename — fix it and re-run. In particular, `docs/adr/0001-...` and any stray repo-root `.md` should be gone after Step 5.

- [ ] **Step 7: Commit**

```bash
git add -A
git commit -m "feat: rebrand setup-matt-pocock-skills → setup-bonai-skills repo-wide"
```

(Uses `-A` because Step 5 may have touched files across multiple buckets.)

---

## Task 7: Add setup-bonai-skills template files

**Files:**
- Create: `skills/engineering/setup-bonai-skills/commands.template.md`
- Create: `skills/engineering/setup-bonai-skills/notion.template.md`

- [ ] **Step 1: Write commands.template.md**

Create `skills/engineering/setup-bonai-skills/commands.template.md`:

````markdown
# Commands

Repo-wide canonical commands. Skills read these verbatim — keep them runnable from a clean shell in the repo root.

## test_command

<command that runs all tests>

## lint_command

<command that runs the linter>

## typecheck_command

<command that runs the type-checker, or "n/a">

## build_command

<command that produces a build, or "n/a">
````

- [ ] **Step 2: Write notion.template.md**

Create `skills/engineering/setup-bonai-skills/notion.template.md`:

````markdown
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

## ADRs DB properties

Area (optional select): <list of area values, or "n/a">

## Domain Glossary DB properties

(no structured properties — page title = term, page body = definition)

---

## DB seed schemas

These are the property definitions to pass to `mcp__notion__notion-create-database` when the user picks `create` for a missing DB in `/setup-bonai-skills`. The output config section above is what gets written to `docs/agents/notion.md` after IDs are known — this section is the *input* used to build the DBs in the first place.

### Issues DB

- **Name** (title) — required
- **Status** (status) — options: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`; default `needs-triage`
- **Category** (select) — options: `bug`, `enhancement`
- **Blocked by** (relation) — relates to Issues DB (self)

### PRDs DB

- **Name** (title) — required

### Handoffs DB

- **Name** (title) — required
- **Date** (date) — default today

### Domain Glossary DB

- **Name** (title) — required (the canonical term)

### ADRs DB

- **Name** (title) — required
- **Status** (select) — options: `proposed`, `accepted`, `deprecated`, `superseded`
- **Area** (select) — options left empty; user adds per-project as needed
- **Superseded by** (relation) — relates to ADRs DB (self)
````

- [ ] **Step 3: Verify both templates exist and are non-empty**

```bash
test -s skills/engineering/setup-bonai-skills/commands.template.md && echo "commands OK"
test -s skills/engineering/setup-bonai-skills/notion.template.md && echo "notion OK"
grep -q "^## DB seed schemas" skills/engineering/setup-bonai-skills/notion.template.md && echo "seed schemas OK"
```
Expected: 3 OK lines. The seed-schemas section is what the SKILL.md feeds to `mcp__notion__notion-create-database` — if it's missing, `/setup-bonai-skills` cannot create missing DBs.

- [ ] **Step 4: Commit**

```bash
git add skills/engineering/setup-bonai-skills/commands.template.md skills/engineering/setup-bonai-skills/notion.template.md
git commit -m "feat: add commands and notion seed templates for setup-bonai-skills"
```

---

## Task 8: Customize tdd

**Files:**
- Modify: `skills/engineering/tdd/SKILL.md`
- Modify: `skills/engineering/tdd/tests.md`

- [ ] **Step 1: Replace the domain-glossary phrasing in SKILL.md**

In `skills/engineering/tdd/SKILL.md`, find this paragraph under `### 1. Planning`:

```
When exploring the codebase, use the project's domain glossary so that test names and interface vocabulary match the project's language, and respect ADRs in the area you're touching.
```

Replace with:

```
When exploring the codebase, ground test names and interface vocabulary in the project's domain language, and respect documented architectural decisions. The pointers to the glossary and ADR sources live in CLAUDE.md / AGENTS.md under the `## Agent skills` section's **Domain language** entry, written by `/setup-bonai-skills`. If that entry is missing, the project hasn't been set up — proceed without grounding rather than guessing where the sources live.
```

This skill does **not** load `../tracker-primitives/` — the Domain language pointer in CLAUDE.md is enough for a read-only consult. Loading the primitives folder is reserved for skills that also *write* to the tracker.

- [ ] **Step 2: Add a Commands section after Philosophy**

In `skills/engineering/tdd/SKILL.md`, immediately after the line `See [tests.md](tests.md) for examples and [mocking.md](mocking.md) for mocking guidelines.` (end of Philosophy), insert a new section:

```markdown

## Commands

This skill never names a test runner directly. The canonical commands live in `docs/agents/commands.md`, written by `/setup-bonai-skills`:

- Run the test suite with `test_command`.
- Run the type-checker with `typecheck_command` (if set).

If `docs/agents/commands.md` is missing, stop and ask the user to run `/setup-bonai-skills` — do not invent a command from `package.json`.

```

- [ ] **Step 3: Verify SKILL.md no longer mentions any test runner by name**

```bash
grep -niE "vitest|jest|pytest|junit|mocha|jasmine|karma" skills/engineering/tdd/SKILL.md
```
Expected: no output.

- [ ] **Step 4: Fix the jest reference in tests.md**

Open `skills/engineering/tdd/tests.md` and replace:

```
  const mockPayment = jest.mock(paymentService);
```

With a runner-agnostic example:

```
  const mockPayment = mock(paymentService);
```

Add a one-line note above the snippet (or amend the surrounding text) to make it clear the helper is illustrative and the actual mocking API depends on the project's test runner — refer to `tests.md`'s opening explanation if needed.

- [ ] **Step 5: Audit the remaining supporting files**

First verify all referenced supporting files actually exist (SKILL.md references them; a broken link is its own bug):

```bash
for f in skills/engineering/tdd/tests.md skills/engineering/tdd/mocking.md skills/engineering/tdd/deep-modules.md skills/engineering/tdd/interface-design.md skills/engineering/tdd/refactoring.md; do
  test -s "$f" && echo "OK: $f" || echo "MISSING: $f"
done
```
Expected: 5 `OK` lines. If any are MISSING, stop and surface to the user — these are referenced by SKILL.md and tdd cannot ship without them.

Then scan for test-runner leakage:

```bash
grep -niE "vitest|jest|pytest|junit|mocha|jasmine|karma" skills/engineering/tdd/mocking.md skills/engineering/tdd/deep-modules.md skills/engineering/tdd/interface-design.md skills/engineering/tdd/refactoring.md skills/engineering/tdd/tests.md
```

If any matches appear, neutralize each one by replacing the runner name with generic language (e.g. "the test runner's mock helper" instead of "`jest.mock`"). Re-run the grep until it returns empty.

- [ ] **Step 6: Verify the whole skill is runner-agnostic**

```bash
grep -rniE "vitest|jest|pytest|junit|mocha|jasmine|karma" skills/engineering/tdd/
```
Expected: no output.

- [ ] **Step 7: Commit**

```bash
git add skills/engineering/tdd/
git commit -m "feat(tdd): use abstract verbs and defer test runner to commands.md"
```

---

## Task 9: Customize diagnose

**Files:**
- Modify: `skills/engineering/diagnose/SKILL.md`
- Verify: `skills/engineering/diagnose/scripts/hitl-loop.template.sh` (already exists)

- [ ] **Step 1: Replace the domain-glossary phrasing in SKILL.md**

In `skills/engineering/diagnose/SKILL.md`, find:

```
When exploring the codebase, use the project's domain glossary to get a clear mental model of the relevant modules, and check ADRs in the area you're touching.
```

Replace with:

```
When exploring the codebase, ground your mental model of the relevant modules in the project's domain language and check documented architectural decisions. The pointers to the glossary and ADR sources live in CLAUDE.md / AGENTS.md under the `## Agent skills` section's **Domain language** entry, written by `/setup-bonai-skills`. If that entry is missing, the project hasn't been set up — proceed without grounding rather than guessing.
```

This skill does **not** load `../tracker-primitives/` — the Domain language pointer in CLAUDE.md is enough for a read-only consult.

- [ ] **Step 2: Defer the Phase 5 regression-test command to commands.md**

In `skills/engineering/diagnose/SKILL.md`, find Phase 5's section. Locate the steps that talk about running a regression test. Add this line at the start of Phase 5 (right under the `## Phase 5 — Fix + regression test` heading):

```
The regression-test command is `test_command` from `docs/agents/commands.md`. If that file is missing, stop and ask the user to run `/setup-bonai-skills`.
```

- [ ] **Step 3: Verify the hitl-loop script exists**

```bash
test -f skills/engineering/diagnose/scripts/hitl-loop.template.sh && echo "hitl-loop OK"
```
Expected: `hitl-loop OK`. (If missing, restore from git or write a minimal stub — but verification at the top of this plan already confirmed the file exists.)

- [ ] **Step 4: Verify no leftover concrete tracker references**

```bash
grep -niE "vitest|jest|pytest|junit|gh issue|github issue|linear" skills/engineering/diagnose/SKILL.md
```
Expected: no output.

- [ ] **Step 5: Commit**

```bash
git add skills/engineering/diagnose/SKILL.md
git commit -m "feat(diagnose): use abstract verbs and defer regression-test command to commands.md"
```

---

## Task 10: Customize grill-with-docs

**Files:**
- Modify: `skills/engineering/grill-with-docs/SKILL.md`
- Rewrite: `skills/engineering/grill-with-docs/CONTEXT-FORMAT.md`
- Rewrite: `skills/engineering/grill-with-docs/ADR-FORMAT.md`

- [ ] **Step 1: Replace SKILL.md with verb-driven content**

Overwrite `skills/engineering/grill-with-docs/SKILL.md` with this content:

````markdown
---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and writes glossary entries and ADRs to the project's tracker inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions.
---

<what-to-do>

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead.

</what-to-do>

<supporting-info>

## Domain awareness

Before grilling starts, use the **`read glossary`** and **`read ADRs in area`** verbs (see `../tracker-primitives/`) to load the existing domain language and architectural decisions. Cache them for the session.

If `docs/agents/notion.md` is missing, stop and ask the user to run `/setup-bonai-skills` — without the tracker config, writes during the session will have nowhere to go.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with an existing glossary entry, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Write glossary entries inline

When a term is resolved, invoke the **`write glossary entry`** verb right there. Don't batch these up — capture them as they happen. The page-body shape is defined in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

Glossary entries are devoid of implementation details. Do not treat the glossary as a spec, scratch pad, or repository for implementation decisions. It is a glossary and nothing else.

### Offer ADRs sparingly

Only offer to invoke **`create ADR`** when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. The page-body shape is defined in [ADR-FORMAT.md](./ADR-FORMAT.md).

</supporting-info>
````

- [ ] **Step 2: Rewrite CONTEXT-FORMAT.md as a page-body template**

Overwrite `skills/engineering/grill-with-docs/CONTEXT-FORMAT.md` with this content:

````markdown
# Glossary entry page-body template

A single Domain Glossary DB page = one canonical term. The **page title** is the term; the **page body** uses this shape:

```md
{One or two sentence description of what the term IS. Define it, do not describe what it does.}

**Aliases to avoid:** {alias1, alias2}  ← omit this line if there are none

**Related terms:** [[Other Term]], [[Another Term]]  ← omit if there are none

**Example dialogue:**

> Dev: "When the customer cancels..."
> Domain expert: "You mean cancels the Order, not the Subscription."
```

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick the best one and list the others under "Aliases to avoid".
- **One or two sentences max.** Define what the term IS, not what it does.
- **Show relationships.** Use `[[Other Term]]` to link to other glossary pages.
- **Flag ambiguities.** If a term is used ambiguously in code or conversation, capture the resolution explicitly in the body.
- **Only include terms specific to this project's domain.** General programming concepts (timeouts, error types, utility patterns) don't belong even if the project uses them extensively.
- **Add an example dialogue.** A short exchange between a dev and a domain expert that clarifies the term's boundary with related concepts.

## Why this shape

Notion's Domain Glossary DB is flat — there is no multi-context branching. One page per term, full stop. If a monorepo needs to separate ordering-domain terms from billing-domain terms, do it with a `Domain` select property on the DB schema (not by spawning multiple glossary DBs).
````

- [ ] **Step 3: Rewrite ADR-FORMAT.md as a page-body template**

Overwrite `skills/engineering/grill-with-docs/ADR-FORMAT.md` with this content:

````markdown
# ADR page-body template

A single ADRs DB page = one decision. The **page title** is the short decision name. The **page body** uses this shape:

```md
{1-3 sentences: what's the context, what did we decide, and why.}
```

That's it. An ADR can be a single paragraph. The value is in recording *that* a decision was made and *why* — not in filling out sections.

## Optional body sections

Only add these when they genuinely help. Most ADRs won't need them.

- **Considered Options** — when the rejected alternatives are worth remembering
- **Consequences** — when non-obvious downstream effects need to be called out

## Optional DB properties

The ADRs DB may have these properties (configured in `docs/agents/notion.md`):

- **Status** (`proposed | accepted | deprecated | superseded`) — useful when decisions are revisited
- **Area** — for multi-area repos, tag the part of the system this ADR governs
- **Superseded by** (relation) — link to the page that replaces this one

## When to offer an ADR

All three must be true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will look at the code and wonder "why on earth did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

### What qualifies

- **Architectural shape.** "We're using a monorepo." "The write model is event-sourced, the read model is projected into Postgres."
- **Integration patterns between contexts.** "Ordering and Billing communicate via domain events, not synchronous HTTP."
- **Technology choices that carry lock-in.** Database, message bus, auth provider, deployment target. Not every library — just the ones that would take a quarter to swap out.
- **Boundary and scope decisions.** "Customer data is owned by the Customer context; other contexts reference it by ID only." The explicit no-s are as valuable as the yes-s.
- **Deliberate deviations from the obvious path.** "We're using manual SQL instead of an ORM because X." Stops the next engineer from "fixing" something that was deliberate.
- **Constraints not visible in the code.** "We can't use AWS because of compliance requirements." "Response times must be under 200ms because of the partner API contract."
- **Rejected alternatives when the rejection is non-obvious.** If you considered GraphQL and picked REST for subtle reasons, record it — otherwise someone will suggest GraphQL again in six months.
````

- [ ] **Step 4: Verify multi-context branching is gone and abstract verbs are present**

```bash
grep -niE "CONTEXT-MAP|multi-context|CONTEXT\\.md|docs/adr/" skills/engineering/grill-with-docs/SKILL.md skills/engineering/grill-with-docs/CONTEXT-FORMAT.md skills/engineering/grill-with-docs/ADR-FORMAT.md
```
Expected: no output. (The new files talk about pages and DBs, not files and folders.)

```bash
grep -nE "read glossary|read ADRs in area|write glossary entry|create ADR" skills/engineering/grill-with-docs/SKILL.md
```
Expected: each verb appears at least once.

- [ ] **Step 5: Commit**

```bash
git add skills/engineering/grill-with-docs/
git commit -m "feat(grill-with-docs): use abstract verbs, drop file-system multi-context branching"
```

---

## Task 11: Verify prototype skill (no body changes)

**Files:**
- Verify only: `skills/engineering/prototype/SKILL.md`, `LOGIC.md`, `UI.md`

Per spec §6.1, prototype gets no body changes — but supporting files must exist.

- [ ] **Step 1: Verify all three files exist**

```bash
ls skills/engineering/prototype/SKILL.md skills/engineering/prototype/LOGIC.md skills/engineering/prototype/UI.md
```
Expected: all three listed.

- [ ] **Step 2: Verify no test-runner or tracker leakage**

```bash
grep -niE "vitest|jest|pytest|junit|gh issue|github issue|setup-matt-pocock-skills|matt-pocock" skills/engineering/prototype/
```
Expected: no output.

If anything turns up, neutralize it inline (same approach as Task 8 step 5) and commit a fix. Otherwise, no commit needed for this task.

---

## Task 12: Cross-cutting hygiene — README, plugin.json, bucket READMEs

**Files:**
- Rewrite: `README.md` (top-level)
- Modify: `.claude-plugin/plugin.json`
- Rewrite: `skills/engineering/README.md`
- Modify: `skills/productivity/README.md` (handoff already removed in Task 2; verify only)

- [ ] **Step 1: Rewrite the top-level README**

Overwrite `/Users/Home/Development/skills/README.md` with this content:

````markdown
# Bonai Skills

A personal, Notion-first set of agent skills I use every day. Packaged as two private tessl tiles under the `bonai-dev` workspace.

| Tile | Skills | Calver |
|---|---|---|
| [`bonai-dev/engineering-skills`](./skills/engineering/) | Daily code-work skills (TDD, diagnosis, grilling against docs, prototyping, repo setup) | `2026.05.0` |
| `bonai-dev/productivity-skills` | General workflow skills (not yet published) | — |

Skills lean on the agent to interrogate the user (via `AskUserQuestion`-style flows) rather than prescribing rigid checklists. The set replaces my prior use of the `superpowers` plugin — bonai is standalone and has no superpowers fallback.

## Layout

```
skills/
  engineering/        ← daily code work (tile: bonai-dev/engineering-skills)
    tracker-primitives/ ← shared MCP/CLI recipes for the abstract-verb contract
  productivity/       ← daily non-code workflow (tile: bonai-dev/productivity-skills, Stage 2)
  misc/               ← kept around but rarely used
  personal/           ← tied to my own setup, not promoted
  in-progress/        ← drafts not yet ready to ship
  deprecated/         ← no longer used
```

## How to install (consumer side)

In a target repo, install the engineering tile from tessl:

```sh
tessl install bonai-dev/engineering-skills@2026.05.0
```

Then run the setup skill once per repo:

```
/setup-bonai-skills
```

This writes `docs/agents/commands.md` (canonical test/lint/typecheck/build commands) and `docs/agents/notion.md` (the 5 Notion database IDs and property mappings). Engineering skills read these to stay language-agnostic and tracker-agnostic.

## The abstract-verb contract

Skill bodies use only **abstract verbs** — never concrete tool calls. `skills/engineering/tracker-primitives/` translates each verb to the chosen backend (Notion, GitHub, or local markdown). Per-repo IDs live in `docs/agents/notion.md` (or equivalent). See [`tracker-primitives/README.md`](./skills/engineering/tracker-primitives/README.md) for the controlled vocabulary.

## Skills

### Engineering (11)

Stage 1 — in the `bonai-dev/engineering-skills@2026.05.0` tile manifest:

- [`setup-bonai-skills`](./skills/engineering/setup-bonai-skills/SKILL.md) — per-repo config scaffolding
- [`tdd`](./skills/engineering/tdd/SKILL.md) — test-driven development loop
- [`diagnose`](./skills/engineering/diagnose/SKILL.md) — disciplined bug-diagnosis loop
- [`grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) — grilling that writes glossary/ADRs inline
- [`prototype`](./skills/engineering/prototype/SKILL.md) — throwaway prototype for logic or UI questions

Stage 2 — in the repo, not yet in the tile manifest:

- [`handoff`](./skills/engineering/handoff/SKILL.md) — conversation handoff documents
- [`triage`](./skills/engineering/triage/SKILL.md) — issue triage state machine
- [`improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) — find deepening opportunities
- [`to-issues`](./skills/engineering/to-issues/SKILL.md) — break a plan into issues
- [`to-prd`](./skills/engineering/to-prd/SKILL.md) — synthesize current context into a PRD
- [`zoom-out`](./skills/engineering/zoom-out/SKILL.md) — higher-level perspective on unfamiliar code

### Productivity (3)

Stage 2 — productivity tile not yet scaffolded:

- [`caveman`](./skills/productivity/caveman/SKILL.md) — ultra-compressed communication mode
- [`grill-me`](./skills/productivity/grill-me/SKILL.md) — non-code interrogation about a plan
- [`write-a-skill`](./skills/productivity/write-a-skill/SKILL.md) — produce a new skill folder

## License

MIT — see [LICENSE](./LICENSE).
````

- [ ] **Step 2: Rewrite `.claude-plugin/plugin.json` (all 14 skills, post-reshuffle)**

CLAUDE.md (the repo's own conventions doc) requires every skill in `engineering/`, `productivity/`, and `misc/` to have an entry in `.claude-plugin/plugin.json`. The Stage-1 scope-to-5 rule applies to the **tile manifest** (`tiles/engineering-skills/tile.json`, populated in Task 13) — not to this local Claude Code plugin manifest.

Overwrite `.claude-plugin/plugin.json` with this content (11 engineering + 3 productivity = 14):

```json
{
  "name": "bonai-skills",
  "skills": [
    "./skills/engineering/setup-bonai-skills",
    "./skills/engineering/tdd",
    "./skills/engineering/diagnose",
    "./skills/engineering/grill-with-docs",
    "./skills/engineering/prototype",
    "./skills/engineering/handoff",
    "./skills/engineering/triage",
    "./skills/engineering/improve-codebase-architecture",
    "./skills/engineering/to-issues",
    "./skills/engineering/to-prd",
    "./skills/engineering/zoom-out",
    "./skills/productivity/caveman",
    "./skills/productivity/grill-me",
    "./skills/productivity/write-a-skill"
  ]
}
```

- [ ] **Step 3: Rewrite `skills/engineering/README.md`**

Overwrite with this content:

````markdown
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
````

- [ ] **Step 4: Verify productivity README has no stale handoff entry**

```bash
grep -i "handoff" skills/productivity/README.md
```
Expected: no output.

- [ ] **Step 5: Verify no remaining `setup-matt-pocock-skills` references in the repo**

```bash
grep -rni "setup-matt-pocock-skills\|matt[ -]?pocock" README.md .claude-plugin/ skills/engineering/ skills/productivity/ 2>/dev/null
```
Expected: no output. (Matches inside `misc/`, `personal/`, `in-progress/`, `deprecated/`, or the `LICENSE` file are out of scope and acceptable.)

- [ ] **Step 6: Verify Stage 1 skill bodies do not reference superpowers**

```bash
grep -rni "superpowers" skills/engineering/setup-bonai-skills/ skills/engineering/tdd/ skills/engineering/diagnose/ skills/engineering/grill-with-docs/ skills/engineering/prototype/ skills/engineering/tracker-primitives/
```
Expected: no output.

- [ ] **Step 7: Unified hygiene grep — acceptance criterion #8**

Spec §8 acceptance criterion #8: "Every Stage 1 customized skill body contains zero references to `setup-matt-pocock-skills`, `matt-pocock`, `gh issue`, or specific test runners by name." Run a single grep against all 5 Stage 1 skill folders to confirm:

```bash
grep -rniE "setup-matt-pocock-skills|matt[ -]?pocock|gh issue|github issue|vitest|jest|pytest|junit|mocha|jasmine|karma" \
  skills/engineering/setup-bonai-skills/ \
  skills/engineering/tdd/ \
  skills/engineering/diagnose/ \
  skills/engineering/grill-with-docs/ \
  skills/engineering/prototype/
```
Expected: no output. (Note: `tracker-primitives/gh.md` legitimately contains `gh issue` — that's why it's excluded from this grep. The criterion is about skill bodies, not shared primitives.)

If any match appears, fix the offending file inline, re-run the grep until clean, then proceed.

- [ ] **Step 8: Commit**

If Step 7's unified hygiene grep produced any inline fixes outside the four files below, stage them too. Easiest path:

```bash
git add -A
git commit -m "chore: rebrand to bonai, scope plugin manifest to Stage 1 skills"
```

(The expected baseline staging is `README.md`, `.claude-plugin/plugin.json`, `skills/engineering/README.md`, `skills/productivity/README.md`. Use `-A` so any Step 7 corrections in skill bodies land in the same commit instead of being orphaned.)

---

## Task 13: Populate the tile manifest

**Files:**
- Modify: `tiles/engineering-skills/tile.json`

The tile was scaffolded in Task 1 but its skills list is empty (or has the scaffold's placeholder). Now populate it with the 5 Stage 1 skills.

- [ ] **Step 1: Re-read the scaffolded tile.json**

```bash
cat tiles/engineering-skills/tile.json
```
Note the exact shape of the skills field (array of strings vs array of objects, relative vs absolute paths, etc.) — captured back in Task 1 Step 3.

- [ ] **Step 2: Edit tile.json to list the 5 Stage 1 skills**

Update the skills entry to point at exactly these paths (translate to whatever shape the scaffold uses):

```
./skills/engineering/setup-bonai-skills
./skills/engineering/tdd
./skills/engineering/diagnose
./skills/engineering/grill-with-docs
./skills/engineering/prototype
```

Leave the `tracker-primitives/` folder out of the skills list — it's shared support, not a skill. (If the tile schema has a separate `resources` or `includes` field for shared folders, add `./skills/engineering/tracker-primitives` there.)

- [ ] **Step 3: Verify the tile manifest matches `.claude-plugin/plugin.json`**

The 5 skill paths in `tile.json` must be exactly the 5 in `.claude-plugin/plugin.json`. Compare:

```bash
grep -oE '\./skills/engineering/[a-z-]+' tiles/engineering-skills/tile.json | sort
grep -oE '\./skills/engineering/[a-z-]+' .claude-plugin/plugin.json | sort
```
Expected: the two listings are identical.

- [ ] **Step 4: Commit**

```bash
git add tiles/engineering-skills/tile.json
git commit -m "feat: populate engineering tile manifest with 5 Stage 1 skills"
```

---

## Task 14: Local validation in a scratch repo

> **User-driven task.** Jay runs these steps interactively — they require live Claude Code sessions, real Notion writes against `bonai-dev`, and judgment calls a non-interactive executor cannot make. An automated executor should stop at the end of Task 13 and hand control back to Jay; do not attempt to execute Task 14 autonomously.

This task does not change files in this repo. It exercises the tile end-to-end in a throwaway repo before publishing.

- [ ] **Step 1: Create a scratch repo**

```bash
mkdir -p /tmp/bonai-stage1-validate && cd /tmp/bonai-stage1-validate && git init && echo "# scratch" > README.md && git add . && git commit -m "init"
```

- [ ] **Step 2: Install the local tile**

Use `mcp__tessl__install` with the local tile path (or however the tessl MCP supports installing un-published tiles from a workspace).

**Decide upfront whether install supports un-published local tiles.** If a quick probe shows `mcp__tessl__install` only accepts a published `workspace/tile@version` reference, the entire smoke-test gate (Steps 3–8) cannot run pre-publish. In that case:

1. Skip Steps 3–9 here.
2. Publish the tile first via Task 15.
3. After Task 15 Step 4 (install from the published tile in a fresh scratch repo), come back and run the smoke tests (Steps 3–9 of this task) against the post-publish scratch repo instead.
4. If a smoke test then fails, the fix → re-publish loop is required (bump to `2026.05.1` per calver, redo Task 15). Flag this to the user before publishing if there is any uncertainty about the Stage 1 skill bodies.

Otherwise, proceed with the un-published install:

Expected: the 5 skills appear under `.claude/` or wherever tessl vendors them in the target repo.

- [ ] **Step 3: Run `/setup-bonai-skills`**

In a Claude Code session against `/tmp/bonai-stage1-validate`, run `/setup-bonai-skills`. Use the user's real Notion workspace (`bonai-dev`) but a throwaway set of databases — either pre-created scratch DBs or let the skill create them via `mcp__notion__notion-create-database`.

After it runs, verify:
```bash
test -s /tmp/bonai-stage1-validate/docs/agents/commands.md && echo "commands OK"
test -s /tmp/bonai-stage1-validate/docs/agents/notion.md && echo "notion OK"
grep -q "## Agent skills" /tmp/bonai-stage1-validate/CLAUDE.md && echo "CLAUDE.md OK"
```
Expected: all three OK lines.

- [ ] **Step 4: Smoke-test `/tdd` against a tiny TS project**

Add a minimal `package.json` with a `test` script (anything that runs — even `echo "no tests"`) and update `commands.md`'s `test_command` to match. Start a Claude Code session and invoke `/tdd` against a trivial feature request ("add a function `add(a, b)` that returns their sum").

Verify by reading the session transcript:
- The agent did not say "vitest", "jest", or any other runner by name.
- The agent did refer to `docs/agents/commands.md` or read the `test_command` value when it ran tests.

- [ ] **Step 5: Smoke-test `/diagnose` Phase 5**

Start a fresh Claude Code session against the scratch repo. Invoke `/diagnose` with a contrived bug (e.g. `add(1, 2)` returns `4`). When the diagnose flow reaches Phase 5, verify the agent uses `test_command` from `commands.md` as the regression-test command (not an inferred one).

- [ ] **Step 6: Smoke-test `/grill-with-docs` writes to Notion**

Start a fresh session. Invoke `/grill-with-docs` with a sample plan that forces a memorable canonical term to surface — e.g. *"I want to add a Cart concept to this app. A Cart is a pre-purchase container distinct from an Order."* Note the canonical term the session settles on (likely `Cart`) before continuing.

Verification has two parts — both must pass:

1. **Negative check: no local file fallback.**

```bash
test ! -f /tmp/bonai-stage1-validate/CONTEXT.md && echo "no local CONTEXT.md OK"
test ! -d /tmp/bonai-stage1-validate/docs/adr && echo "no local docs/adr OK"
```
Expected: both OK lines. (The scratch repo never had these files, so this only catches the regression where the skill *creates* them — which is the failure mode we care about.)

2. **Positive check: the page exists in Notion.**

Call `mcp__notion__notion-fetch` against the Domain Glossary DB ID from `/tmp/bonai-stage1-validate/docs/agents/notion.md` and confirm a page exists whose title matches the canonical term from the session (e.g. `Cart`). If `mcp__notion__notion-search` is faster for title lookups, that works too.

Expected: the page is present, with a body that uses the `CONTEXT-FORMAT.md` shape (one or two sentence definition; "Aliases to avoid" / "Related terms" if present).

If only the negative check passes but the positive check fails, the skill silently did nothing — treat as a Step 8 failure.

- [ ] **Step 7: Verify `/prototype` invokes cleanly**

Start a fresh session. Invoke `/prototype` with a logic-prototype prompt. Verify the agent picks the LOGIC branch and walks into the supporting `LOGIC.md` content without erroring on missing references.

- [ ] **Step 8: If any smoke test fails, fix inline**

Treat any smoke-test failure as a bug in the corresponding skill body. Fix the skill, re-run the failing smoke test, then continue. Do not proceed to Task 15 until all six smoke tests pass.

- [ ] **Step 9: Clean up scratch Notion pages and the scratch repo**

The smoke tests created pages in the user's real `bonai-dev` Notion workspace (glossary entries, possibly an issue page, possibly DBs if Step 3 chose `create`). Delete or archive them so they don't pollute the user's tracker:

- If `Step 3` created throwaway DBs, archive them via Notion's UI or call `mcp__notion__notion-update-data-source` to mark them archived.
- If `Step 6` wrote glossary entries to a real Domain Glossary DB, delete just those pages (look up by title from the smoke test).
- Confirm with the user before deleting anything you're not sure was created by this run.

Then remove the scratch repo:

```bash
rm -rf /tmp/bonai-stage1-validate
```

- [ ] **Step 10: Commit any fixes made during smoke testing**

If Step 8 produced fixes, commit them with a message like:
```bash
git -C /Users/Home/Development/skills commit -am "fix(stage1): address issues found during scratch-repo validation"
```

If no fixes were needed, no commit.

---

## Task 15: Publish the tile at v2026.05.0

> **User-driven task.** Publish writes to the real `bonai-dev` tessl registry — Jay runs this once Task 14 smoke tests are green. An automated executor should not run `tessl tile publish` autonomously; it is a one-way action.

- [ ] **Step 1: Confirm working tree is clean**

```bash
git status
```
Expected: clean working tree on `main` (or whatever branch we've been committing on).

- [ ] **Step 2: Publish via the tessl CLI**

The tessl MCP does not expose a publish primitive — use the documented CLI command [`tessl tile publish`](https://docs.tessl.io/reference/cli-commands#tessl-tile-publish):

```bash
tessl tile publish --dry-run tiles/engineering-skills
```

The dry-run runs pre-publish checks (manifest validation, eval scenarios, etc.) without writing to the registry. Read the output and confirm no validation errors.

Then publish for real:

```bash
tessl tile publish tiles/engineering-skills
```

Prerequisites (verify before running):
- Logged in: `tessl status` should show the `bonai-dev` workspace authenticated. If not, run `tessl login` interactively.
- Jay has publisher/owner role on `bonai-dev` (this is his personal workspace, so this should hold — but the dry-run will surface a permission error if not).
- `tiles/engineering-skills/tile.json` declares `workspace: bonai-dev` and `version: 2026.05.0` (set in Tasks 1 and 13). If either is missing, pass `--workspace bonai-dev` and/or `--version 2026.05.0` on the command line — but it is cleaner to fix the manifest and re-run.

Expected: the tile is published, version `2026.05.0`, visibility `private` (inherits from the scaffolded tile metadata).

- [ ] **Step 3: Confirm via `mcp__tessl__status`**

Call `mcp__tessl__status` and look for `bonai-dev/engineering-skills` at `2026.05.0`, in sync.

If status does not show the tile, debug with the user — do not attempt a re-publish blind.

- [ ] **Step 4: Install from the published tile in a fresh scratch repo**

```bash
mkdir -p /tmp/bonai-stage1-postpublish && cd /tmp/bonai-stage1-postpublish && git init
```

Call `mcp__tessl__install` for `bonai-dev/engineering-skills@2026.05.0`. Expected: install succeeds; the 5 Stage 1 skills are now available in the scratch repo.

- [ ] **Step 5: Clean up**

```bash
rm -rf /tmp/bonai-stage1-postpublish
```

- [ ] **Step 6: Tag the release locally**

```bash
git tag engineering-skills-v2026.05.0
```

(Push the tag only if the user asks — per the global guidance, never push without explicit confirmation.)

- [ ] **Step 7: Announce done**

Summarize for the user:
- Tile `bonai-dev/engineering-skills` published at `2026.05.0`, private.
- 5 skills in the manifest: `setup-bonai-skills`, `tdd`, `diagnose`, `grill-with-docs`, `prototype`.
- 6 other engineering skills + 3 productivity skills remain in the repo for Stage 2.
- Mapping back to spec §8 acceptance criteria — confirm each box.

---

## Acceptance criteria (from spec §8)

Verify each before declaring Stage 1 done:

- [ ] `mcp__tessl__status` shows `bonai-dev/engineering-skills` in sync at `2026.05.0` — Task 15 Step 3.
- [ ] `tessl install bonai-dev/engineering-skills@2026.05.0` in a scratch repo succeeds — Task 15 Step 4.
- [ ] `/setup-bonai-skills` produces a valid `docs/agents/commands.md` and `docs/agents/notion.md` — Task 14 Step 3.
- [ ] `/tdd` runs without naming a test runner and uses `commands.md` — Task 14 Step 4.
- [ ] `/diagnose` Phase 5 uses `commands.md` for the regression-test command — Task 14 Step 5.
- [ ] `/grill-with-docs` writes glossary entries to the Domain Glossary DB and ADRs to the ADRs DB (not repo files) — Task 14 Step 6.
- [ ] `/prototype` runs unchanged — Task 14 Step 7.
- [ ] Every Stage 1 skill body contains zero references to `setup-matt-pocock-skills`, `matt-pocock`, `gh issue`, or specific test runners — Task 12 Step 7 (the unified hygiene grep is authoritative; Tasks 8 Step 6, 9 Step 4, 11 Step 2, and 12 Steps 5–6 are intermediate per-skill checks).
- [ ] The engineering tile manifest at v2026.05.0 contains exactly the 5 Stage 1 skills — Task 13 Step 3.

## Open items deferred to implementation (from spec §9)

- **`tile.json` schema** — Task 1 Step 4 captures the actual schema; Task 13 adapts to it.
- **Default Issues DB property shape** — Task 7 ships Status + Category as the seed. If the user prefers multi-select Labels (closer GitHub parity), update `notion.template.md` inline during the corresponding `/setup-bonai-skills` smoke test (Task 14 Step 3) and amend the spec.

---

## Out of scope for this plan (deferred to Stage 2)

- The 6 remaining engineering skills (`triage`, `to-issues`, `to-prd`, `improve-codebase-architecture`, `zoom-out`, `handoff`)
- The productivity tile (`bonai-dev/productivity-skills`) — not scaffolded in Stage 1
- The 3 productivity skills (`caveman`, `grill-me`, `write-a-skill`)
- Skills under `misc/`, `personal/`, `in-progress/`, `deprecated/`
- Public tessl publishing (tiles remain private)
- Migration tooling for existing repos' `CONTEXT.md` / `docs/adr/` content into Notion
