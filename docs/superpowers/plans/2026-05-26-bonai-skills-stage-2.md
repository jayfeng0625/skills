# Bonai Skills Stage 2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish `bonai-dev/engineering-skills@YYYY.M.D` (re-publish at year.month.day calver, adding the 6 remaining engineering skills) and `bonai-dev/productivity-skills@YYYY.M.D` (first publish, 3 skills) — completing the bonai skill set so it fully replaces the `superpowers` plugin.

**Architecture:** Stage 1's three-layer contract is preserved (skill bodies use abstract verbs, `tracker-primitives/` translates verbs to MCP/CLI, per-repo `docs/agents/notion.md` holds IDs). Stage 2 extends the controlled vocabulary by one verb (`post agent brief`), introduces an `Epic` select column on the Handoffs DB, and ships the productivity tile alongside an engineering-tile re-publish.

**Tech Stack:** Markdown skills, Tessl MCP (`mcp__tessl__new_tile`, `mcp__tessl__status`, `mcp__tessl__install`), Notion MCP recipes (`mcp__notion__notion-create-pages`, `mcp__notion__notion-update-data-source`), git for renames and re-publish.

**Source spec:** `docs/superpowers/specs/2026-05-25-bonai-skills-customization-design.md` — updated in Task 1 to reflect post-grill decisions.

**Grill record:** Decisions from the 2026-05-26 grilling session are encoded inline in the acceptance criteria at the end of this plan; the session transcript is not preserved here. Key deltas to remember:

- Calver shape changes from `YYYY.M.PATCH` to `YYYY.M.D` (year.month.day of publish).
- New verb `post agent brief` (child page of issue page in Notion).
- `/tdd` and `/diagnose` are removed from the tracker-primitives vocabulary table — they use the read-without-primitives path (Stage 1's existing pattern).
- Handoffs DB gains an `Epic` select column for in-project workstream subdivision.
- W011 advisory accepted as-is — no Quarantine preamble, no Trust Model README section. Matches Matt's neutral framing; Notion-forcing already narrows the threat surface.
- Productivity tile is zero-config (no `setup-productivity-skills` skill).
- `/zoom-out` ships as its existing 1-liner; spec §6.2 phrase about "loads supporting refs (modules map, callers index)" is stripped.

**Scope note:** This plan covers Stage 2 only — 6 engineering skill customizations + 3 productivity skills + new verb + Epic column + spec updates + two tile publishes. Stage 1 outputs (`bonai-dev/engineering-skills@2026.5.0`, the 5 customized skills, `tracker-primitives/`, `/setup-bonai-skills`, repo-wide bonai rebrand) are pre-conditions and not redone.

---

## Task index

| # | Task | Key files | Notes |
|---|---|---|---|
| 1 | Spec updates (post-grill decisions) | `docs/superpowers/specs/2026-05-25-bonai-skills-customization-design.md` | §2 calver, §4.2 verb, §4.3 Epic, §6.2 zoom-out |
| 2 | Add `post agent brief` to tracker-primitives | `tracker-primitives/README.md`, `notion.md`, `gh.md`, `local.md` | New verb across all 4 backend files |
| 3 | Fix vocabulary table — remove `/tdd` and `/diagnose` from verb rows | `tracker-primitives/README.md` | Stage 1 leftover; they use read-without-primitives |
| 4 | Update setup skill — Epic column + Handoffs DB schema | `setup-bonai-skills/SKILL.md`, `notion.template.md` | Adds Epic to seed schema + setup flow |
| 5 | Customize `/triage` | `skills/engineering/triage/SKILL.md` | Biggest rewrite — 6 verbs, no GitHub phrasing |
| 6 | Customize `/to-issues` | `skills/engineering/to-issues/SKILL.md` | `create issue page` + `ready-for-agent` at creation + `Blocked by` relation |
| 7 | Customize `/to-prd` | `skills/engineering/to-prd/SKILL.md` | `create PRD page` + `ready-for-agent` marker |
| 8 | Customize `/improve-codebase-architecture` | `skills/engineering/improve-codebase-architecture/SKILL.md` | Abstract verbs + HTML report + drop literal `CONTEXT.md`/`docs/adr/` |
| 9 | Verify `/zoom-out` (1-liner unchanged) | `skills/engineering/zoom-out/SKILL.md` | No body change; verify only |
| 10 | Customize `/handoff` | `skills/engineering/handoff/SKILL.md` | Per-repo Handoffs DB + Epic + canonical section order |
| 11 | Customize `/grill-me` | `skills/productivity/grill-me/SKILL.md` | Non-code scope statement + non-overlap with `/grill-with-docs` |
| 12 | Verify `/caveman` + `/write-a-skill` (unchanged) | productivity skills | No body changes; hygiene grep only |
| 13 | Cross-cutting hygiene | `README.md`, bucket READMEs | Top-level rebrand for two-tile completion |
| 14 | Scaffold productivity tile | `tiles/productivity-skills/tile.json` | via `mcp__tessl__new_tile` |
| 15 | Populate engineering tile manifest | `tiles/engineering-skills/tile.json` | 5 Stage 1 + 6 Stage 2 = 11 skills |
| 16 | Populate productivity tile manifest | `tiles/productivity-skills/tile.json` | 3 productivity skills |
| 17 | Local validation in a scratch repo | (no repo file changes) | **User-driven** — interactive smoke tests |
| 18 | Publish both tiles at YYYY.M.D | `tessl tile publish` | **User-driven** — one-way action |

---

## File Structure

**New files:**
- `tiles/productivity-skills/tile.json` — scaffolded by `mcp__tessl__new_tile`, populated in Task 16

**Modified in place:**
- `docs/superpowers/specs/2026-05-25-bonai-skills-customization-design.md` — §2/§4.2/§4.3/§6.2 edits (Task 1)
- `skills/engineering/tracker-primitives/README.md` — new verb row, remove `/tdd` and `/diagnose` from existing rows (Tasks 2 + 3)
- `skills/engineering/tracker-primitives/notion.md` — `post agent brief` recipe (Task 2)
- `skills/engineering/tracker-primitives/gh.md` — `post agent brief` reference recipe (Task 2)
- `skills/engineering/tracker-primitives/local.md` — `post agent brief` reference recipe (Task 2)
- `skills/engineering/setup-bonai-skills/SKILL.md` — Epic-column setup flow (Task 4)
- `skills/engineering/setup-bonai-skills/notion.template.md` — Handoffs DB seed schema gains Epic (Task 4)
- `skills/engineering/triage/SKILL.md` (Task 5)
- `skills/engineering/to-issues/SKILL.md` (Task 6)
- `skills/engineering/to-prd/SKILL.md` (Task 7)
- `skills/engineering/improve-codebase-architecture/SKILL.md` (Task 8)
- `skills/engineering/handoff/SKILL.md` (Task 10)
- `skills/productivity/grill-me/SKILL.md` (Task 11)
- `README.md` (top-level — Task 13)
- `skills/engineering/README.md` — drop Stage 1 / Stage 2 split (Task 13)
- `skills/productivity/README.md` — match the 3-skill productivity tile (Task 13)
- `tiles/engineering-skills/tile.json` — bump version + add 6 skills (Task 15)

**Untouched:**
- All Stage 1 customized skills (`setup-bonai-skills`, `tdd`, `diagnose`, `grill-with-docs`, `prototype`) — verified clean, not re-edited
- `skills/engineering/zoom-out/SKILL.md` — already a 1-liner; verify only
- `skills/productivity/caveman/SKILL.md` and `skills/productivity/write-a-skill/SKILL.md` — verify only
- `.claude-plugin/plugin.json` — already lists all 14 skills post-Stage 1; no change
- `tessl.json` — already `bonai-dev/skills`

---

## Task 1: Spec updates (post-grill decisions)

**Files:**
- Modify: `docs/superpowers/specs/2026-05-25-bonai-skills-customization-design.md`

Record the 2026-05-26 grill decisions in the spec so future readers see the agreed shape, not the pre-grill one.

- [ ] **Step 1: Update §2 calver shape**

In the spec's §2 Foundational decisions table, find the **Versioning** row:

```
| Versioning | Calver (`2026.05.0`), private | Continuously-evolving personal set; no public commitment yet |
```

Replace with:

```
| Versioning | Calver (`YYYY.M.D` — year.month.day of publish; no zero-padding), private | Continuously-evolving personal set; no public commitment yet. Stage 1 used the earlier `YYYY.M.PATCH` shape and shipped at `2026.5.0`; from Stage 2 onward, the patch slot encodes day-of-month. |
```

- [ ] **Step 2: Add `post agent brief` to §4.2 vocabulary table**

In §4.2, after the `create handoff page` row, insert:

```
| `post agent brief` | `/triage` |
```

- [ ] **Step 3: Note the Epic column in §4.3**

In §4.3 The 5 Notion databases, find the **Handoffs DB** entry:

```
3. **Handoffs DB** — cross-session handoff pages
```

Replace with:

```
3. **Handoffs DB** — cross-session handoff pages; carries an `Epic` select column to subdivide handoffs by workstream within a project (see §4.4 and `/handoff`)
```

Also, in §4.4 the example `docs/agents/notion.md` block, find the `Issues DB properties` section and append a new `## Handoffs DB properties` block before the closing fence:

```
## Handoffs DB properties

Epic (select): per-project workstream values (e.g. `Stage 2 design`); add options as new workstreams begin.
```

- [ ] **Step 4: Strip `/zoom-out`'s "supporting refs" phrase from §6.2**

In §6.2 zoom-out, find:

```
- Start as a 1-liner skill that loads supporting refs (modules map, callers index) when invoked. Stays close to today's terse shape.
```

Replace with:

```
- Stays as today's terse 1-liner. Domain language grounding flows through the existing CLAUDE.md `## Agent skills` → **Domain language** entry; no supporting-refs (modules map / callers index) loading is wired up. Evolution toward a structured workflow is a future-work item, not a Stage 2 deliverable.
```

- [ ] **Step 5: Update §6.2 `/handoff` to note the Epic prompt**

In §6.2 `/handoff`, find the existing bullet about Notion page in Handoffs DB:

```
- Fixed-template Notion page in Handoffs DB.
- Sections: **Goal / What's done / Open questions / Suggested skills / Key files / Sensitive-info note**.
- Abstract verb: `create handoff page`.
```

Replace with:

```
- Fixed-template Notion page in the per-repo Handoffs DB.
- Skill body asks **which Epic** this handoff belongs to at invocation, before composing the body. The Epic value is one of the options on the Handoffs DB `Epic` select property; the skill may also offer to add a new option if no existing value fits.
- Sections (in this order): **Goal / What's done / Open questions / Suggested skills / Key files / Sensitive-info note**.
- Abstract verb: `create handoff page` (sets `Epic` and the Date property; Date defaults to today).
```

- [ ] **Step 6: Verify the spec changes**

```bash
grep -n "YYYY.M.D" docs/superpowers/specs/2026-05-25-bonai-skills-customization-design.md
grep -n "post agent brief" docs/superpowers/specs/2026-05-25-bonai-skills-customization-design.md
grep -n "Epic" docs/superpowers/specs/2026-05-25-bonai-skills-customization-design.md
```
Expected: each grep returns at least one match.

```bash
grep -n "loads supporting refs" docs/superpowers/specs/2026-05-25-bonai-skills-customization-design.md
```
Expected: no output.

- [ ] **Step 7: Commit**

```bash
git add docs/superpowers/specs/2026-05-25-bonai-skills-customization-design.md
git commit -m "docs(spec): record Stage 2 post-grill decisions (calver, agent brief verb, Epic, zoom-out)"
```

---

## Task 2: Add `post agent brief` to tracker-primitives

**Files:**
- Modify: `skills/engineering/tracker-primitives/README.md`
- Modify: `skills/engineering/tracker-primitives/notion.md`
- Modify: `skills/engineering/tracker-primitives/gh.md`
- Modify: `skills/engineering/tracker-primitives/local.md`

- [ ] **Step 1: Add the verb row to the README controlled-vocabulary table**

In `skills/engineering/tracker-primitives/README.md`'s vocabulary table, insert a new row after the existing `post triage note` row:

```
| `post agent brief` | `/triage` |
```

- [ ] **Step 2: Add the Notion recipe**

In `skills/engineering/tracker-primitives/notion.md`, after the `### \`post triage note\`` section, insert:

````markdown
### `post agent brief`

Used by `/triage` to attach a long, structured work specification to an issue when the issue moves to `ready-for-agent` (or `ready-for-human`). The brief lives as a **child page** of the issue page so it has a stable URL and isn't truncated to Notion's comment length limits.

Tool: `mcp__notion__notion-create-pages`
- Parent: `{ page_id: <issue page id> }`
- Title: short brief name (e.g. "Agent brief: <issue title>")
- Body: rendered from the `AGENT-BRIEF.md` template in `skills/engineering/triage/`

When the issue is later fetched (`mcp__notion__notion-fetch` on the issue page id), the brief appears in the returned children — the AFK agent reads it directly without needing a separate lookup.
````

- [ ] **Step 3: Add the gh.md reference recipe**

In `skills/engineering/tracker-primitives/gh.md`, after the `### \`post triage note\`` section, insert:

````markdown
### `post agent brief`

GitHub has no native "child page" concept on an issue. Two equivalents:

- **Long comment** (Stage 1 fallback): `gh issue comment <number> --body "<rendered brief>"`. Works but loses the URL-stable child-page property of the Notion backend.
- **Linked discussion / wiki page**: open a corresponding wiki page or repo discussion via `gh api`, then link to it from a short `gh issue comment` on the issue.

Stage 2 ships the long-comment form by default for the gh backend; consuming skills (`/triage`) treat it as the fallback path when the chosen backend is gh.
````

- [ ] **Step 4: Add the local.md reference recipe**

In `skills/engineering/tracker-primitives/local.md`, after the `### \`post triage note\`` section, insert:

````markdown
### `post agent brief`

Append a `## Agent brief` section to the bottom of the issue file, or write a sibling file at `.scratch/issues/<id>-brief.md` if the body exceeds a comfortable size. Either choice is valid; the file-system has no "child page" structure to mirror Notion's.
````

- [ ] **Step 5: Verify each file mentions the new verb**

```bash
for f in skills/engineering/tracker-primitives/README.md skills/engineering/tracker-primitives/notion.md skills/engineering/tracker-primitives/gh.md skills/engineering/tracker-primitives/local.md; do
  grep -q "post agent brief" "$f" && echo "OK: $f" || echo "MISSING: $f"
done
```
Expected: 4 `OK` lines.

- [ ] **Step 6: Commit**

```bash
git add skills/engineering/tracker-primitives/
git commit -m "feat(tracker-primitives): add post agent brief verb across all backends"
```

---

## Task 3: Fix vocabulary table — remove `/tdd` and `/diagnose` from verb rows

**Files:**
- Modify: `skills/engineering/tracker-primitives/README.md`

Stage 1 leftover bug: the controlled vocabulary table lists `/tdd` and `/diagnose` as users of `read glossary` and `read ADRs in area`, but they don't invoke the verbs — they use the read-without-primitives path. The table's own "Read verbs without loading primitives" section explains this. Fix the table.

- [ ] **Step 1: Trim the `read glossary` row**

In the vocabulary table, find:

```
| `read glossary` | `/tdd`, `/diagnose`, `/grill-with-docs`, `/triage`, `/to-issues`, `/to-prd`, `/improve-codebase-architecture` |
```

Replace with:

```
| `read glossary` | `/grill-with-docs`, `/triage`, `/to-issues`, `/to-prd`, `/improve-codebase-architecture` |
```

- [ ] **Step 2: Trim the `read ADRs in area` row**

Find:

```
| `read ADRs in area` | `/tdd`, `/diagnose`, `/grill-with-docs`, `/triage`, `/improve-codebase-architecture` |
```

Replace with:

```
| `read ADRs in area` | `/grill-with-docs`, `/triage`, `/improve-codebase-architecture` |
```

- [ ] **Step 3: Verify `/tdd` and `/diagnose` no longer appear in the vocabulary table rows**

```bash
sed -n '/^## Controlled vocabulary/,/^## /p' skills/engineering/tracker-primitives/README.md | grep -E "/tdd|/diagnose"
```
Expected: no output. (The section after the table — "Read verbs without loading primitives" — does mention `/tdd` and `/diagnose`. That mention should remain.)

- [ ] **Step 4: Commit**

```bash
git add skills/engineering/tracker-primitives/README.md
git commit -m "fix(tracker-primitives): drop /tdd and /diagnose from verb table rows"
```

---

## Task 4: Update setup-bonai-skills — Epic column + Handoffs DB schema

**Files:**
- Modify: `skills/engineering/setup-bonai-skills/SKILL.md`
- Modify: `skills/engineering/setup-bonai-skills/notion.template.md`

New repos running `/setup-bonai-skills` after Stage 2 must get a Handoffs DB with an `Epic` select column so `/handoff` works on first use. Update the seed schema and the interactive flow.

- [ ] **Step 1: Add Epic to the Handoffs DB seed schema**

In `skills/engineering/setup-bonai-skills/notion.template.md`, find the **Handoffs DB** entry under `## DB seed schemas`:

```
### Handoffs DB

- **Name** (title) — required
- **Date** (date) — default today
```

Replace with:

```
### Handoffs DB

- **Name** (title) — required
- **Date** (date) — default today
- **Epic** (select) — per-project workstream values; seed empty (user adds options on first use) or with a placeholder option
```

- [ ] **Step 2: Add a Handoffs DB properties output block to the template**

Still in `notion.template.md`, after the `## ADRs DB properties` block, insert:

```
## Handoffs DB properties

Epic (select): per-project workstream values; add options in Notion as new workstreams begin.
```

- [ ] **Step 3: Mention Epic in the SKILL.md Notion walkthrough**

In `skills/engineering/setup-bonai-skills/SKILL.md`, find step 3 of the Notion walkthrough. After the existing **Property mappings for the Issues DB** instruction, append a new paragraph:

```
4. **Property mappings for the Handoffs DB.** The Handoffs DB has an `Epic` select property — used by `/handoff` to subdivide handoffs by workstream within this project. If the DB was just created from the seed schema, the option list is empty; tell the user they will add Epic options on first use of `/handoff`. If the DB already exists, capture the property name (default `Epic`) so `/handoff` can match it.
```

Renumber existing steps below this insertion if needed (the next subsection is Step 4 of the Process — leave that numbering alone, this is a sub-step within the Notion walkthrough's "ask in sequence" list).

- [ ] **Step 4: Verify both files reference Epic**

```bash
grep -q "Epic" skills/engineering/setup-bonai-skills/notion.template.md && echo "template OK"
grep -q "Epic" skills/engineering/setup-bonai-skills/SKILL.md && echo "SKILL OK"
```
Expected: both OK.

- [ ] **Step 5: Commit**

```bash
git add skills/engineering/setup-bonai-skills/
git commit -m "feat(setup-bonai-skills): add Epic select column to Handoffs DB seed schema"
```

---

## Task 5: Customize `/triage`

**Files:**
- Modify: `skills/engineering/triage/SKILL.md`

`/triage`'s body is mostly verb-ready — it already speaks in canonical roles and `setup-bonai-skills` is correctly referenced. The Stage 2 work is to (a) make verb invocations explicit, (b) name the new `post agent brief` verb where the body currently says "agent brief comment", and (c) ensure no GitHub-shaped phrasing remains.

- [ ] **Step 1: Add a verbs preamble after Roles**

After the `## Roles` section (ending around "the actual label strings used in the issue tracker may differ"), insert a new section:

````markdown
## Verbs used

This skill uses the following abstract verbs from `tracker-primitives/`:

- `transition state` — when applying a state role to an issue
- `post triage note` — for the reporter-facing notes (template below)
- `post agent brief` — for the agent-facing work specification ([AGENT-BRIEF.md](AGENT-BRIEF.md))
- `create issue page` — when triage produces a new issue (rare; mainly via `/to-issues`)
- `read glossary` — to ground the issue summary in the project's domain language
- `read ADRs in area` — to avoid re-suggesting work that an ADR forbids

Backend-specific MCP / CLI mappings live in `../tracker-primitives/<backend>.md`.
````

- [ ] **Step 2: Update the "Apply the outcome" subsections to name verbs**

In the existing `## Triage a specific issue` section, find the **Apply the outcome** block:

```
5. **Apply the outcome:**
   - `ready-for-agent` — post an agent brief comment ([AGENT-BRIEF.md](AGENT-BRIEF.md)).
   - `ready-for-human` — same structure as an agent brief, but note why it can't be delegated (judgment calls, external access, design decisions, manual testing).
   - `needs-info` — post triage notes (template below).
   - `wontfix` (bug) — polite explanation, then close.
   - `wontfix` (enhancement) — write to `.out-of-scope/`, link to it from a comment, then close ([OUT-OF-SCOPE.md](OUT-OF-SCOPE.md)).
   - `needs-triage` — apply the role. Optional comment if there's partial progress.
```

Replace with:

```
5. **Apply the outcome:**
   - `ready-for-agent` — invoke `transition state` to set the state role, then `post agent brief` ([AGENT-BRIEF.md](AGENT-BRIEF.md)) as a child page of the issue.
   - `ready-for-human` — invoke `transition state`, then `post agent brief` with the same template but note why it can't be delegated (judgment calls, external access, design decisions, manual testing).
   - `needs-info` — invoke `transition state` (if not already in `needs-info`), then `post triage note` (template below) for the reporter.
   - `wontfix` (bug) — invoke `transition state` to `wontfix` and post a brief explanation via `post triage note`; close the issue.
   - `wontfix` (enhancement) — write to `.out-of-scope/` ([OUT-OF-SCOPE.md](OUT-OF-SCOPE.md)), then invoke `transition state` to `wontfix` and link to the file from a `post triage note`; close.
   - `needs-triage` — invoke `transition state` to apply the role. Optional `post triage note` if there's partial progress.
```

- [ ] **Step 3: Update the "Quick state override" section**

Find:

```
If the maintainer says "move #42 to ready-for-agent", trust them and apply the role directly. Confirm what you're about to do (role changes, comment, close), then act. Skip grilling. If moving to `ready-for-agent` without a grilling session, ask whether they want to write an agent brief.
```

Replace with:

```
If the maintainer says "move #42 to ready-for-agent", trust them and invoke `transition state` directly. Confirm what you're about to do (role changes, brief, close), then act. Skip grilling. If moving to `ready-for-agent` without a grilling session, ask whether they want to invoke `post agent brief` separately.
```

- [ ] **Step 4: Verify no GitHub-shaped phrasing or matt-pocock leftovers**

```bash
grep -niE "gh issue|github issue|apply label|add label|matt[ -]?pocock|setup-matt-pocock-skills" skills/engineering/triage/SKILL.md
```
Expected: no output.

```bash
grep -nE "transition state|post triage note|post agent brief|read glossary|read ADRs in area" skills/engineering/triage/SKILL.md
```
Expected: each verb appears at least once.

- [ ] **Step 5: Verify supporting files still exist**

```bash
test -s skills/engineering/triage/AGENT-BRIEF.md && echo "AGENT-BRIEF OK"
test -s skills/engineering/triage/OUT-OF-SCOPE.md && echo "OUT-OF-SCOPE OK"
```
Expected: both OK.

- [ ] **Step 6: Commit**

```bash
git add skills/engineering/triage/
git commit -m "feat(triage): use abstract verbs and name post-agent-brief explicitly"
```

---

## Task 6: Customize `/to-issues`

**Files:**
- Modify: `skills/engineering/to-issues/SKILL.md`

Matt's original `/to-issues` "publishes issues with the correct triage label" — `ready-for-agent` — so the issues skip triage. Preserve that pattern using the bonai `transition state` semantics: create with Status defaulting to `needs-triage`, then transition to `ready-for-agent` at the end of creation.

- [ ] **Step 1: Add a verbs preamble after the intro**

After the first paragraph ("Break a plan into independently-grabbable issues using vertical slices (tracer bullets).") and before "The issue tracker and triage label vocabulary should have been provided to you", insert:

````markdown
## Verbs used

- `create issue page` — for each vertical slice
- `transition state` — to move each new issue to `ready-for-agent` immediately after creation (Matt's "no additional triage needed" pattern; these issues are already specified enough to ship)
- `read glossary` — to align titles and descriptions with the project's domain language

Backend-specific MCP / CLI mappings live in `../tracker-primitives/<backend>.md`.
````

- [ ] **Step 2: Rewrite "Publish the issues to the issue tracker" to name the verbs**

Find the existing step 5 in the Process:

```
### 5. Publish the issues to the issue tracker

For each approved slice, publish a new issue to the issue tracker. Use the issue body template below. These issues are considered ready for AFK agents, so publish them with the correct triage label unless instructed otherwise.

Publish issues in dependency order (blockers first) so you can reference real issue identifiers in the "Blocked by" field.
```

Replace with:

```
### 5. Publish the issues

For each approved slice, invoke `create issue page` (Issues DB) with the body rendered from the template below.

Publish issues in **dependency order** (blockers first) so the `Blocked by` relation can reference real, already-created issue page IDs. The Notion `Blocked by` property is a relation to the Issues DB (self) — set its value to the array of blocking issue page IDs at creation time. For non-Notion backends, see `../tracker-primitives/<backend>.md` for the equivalent expression.

After each issue is created, immediately invoke `transition state` to move it from `needs-triage` (the seed default) to `ready-for-agent`. These slices are already specified enough to ship — no additional triage step is needed. (This preserves Matt's "publish with the correct triage label" pattern from the original `/to-issues`.)
```

- [ ] **Step 3: Verify the body content**

```bash
grep -nE "create issue page|transition state|read glossary|Blocked by" skills/engineering/to-issues/SKILL.md
```
Expected: each appears at least once.

```bash
grep -niE "gh issue|github issue|setup-matt-pocock-skills|matt[ -]?pocock|vitest|jest|pytest|junit" skills/engineering/to-issues/SKILL.md
```
Expected: no output.

- [ ] **Step 4: Commit**

```bash
git add skills/engineering/to-issues/SKILL.md
git commit -m "feat(to-issues): use create-issue-page + transition-state to ready-for-agent"
```

---

## Task 7: Customize `/to-prd`

**Files:**
- Modify: `skills/engineering/to-prd/SKILL.md`

Matt's original publishes the PRD with the `ready-for-agent` triage label — no additional triage. Bonai equivalent: `create PRD page`, then `transition state` to `ready-for-agent` on the corresponding tracking issue (if `/to-prd` creates a parent issue alongside the PRD, transition that). If `/to-prd` only creates the PRD page (no separate issue), there's nothing to transition — the PRDs DB has no Status property.

- [ ] **Step 1: Add a verbs preamble**

After the first sentence ("This skill takes the current conversation context and codebase understanding and produces a PRD..."), insert:

````markdown
## Verbs used

- `create PRD page` — to write the PRD into the PRDs DB
- `read glossary` — to align the PRD's vocabulary with the project's domain language
- `read ADRs in area` — to respect documented architectural decisions

Backend-specific MCP / CLI mappings live in `../tracker-primitives/<backend>.md`.
````

- [ ] **Step 2: Rewrite step 3 to name the verb and the no-additional-triage pattern**

Find step 3:

```
3. Write the PRD using the template below, then publish it to the project issue tracker. Apply the `ready-for-agent` triage label - no need for additional triage.
```

Replace with:

```
3. Write the PRD using the template below, then invoke `create PRD page` (PRDs DB).

The PRDs DB does not carry a triage state property — the PRD itself is the deliverable, not a tracked workstream. If `/to-prd` is invoked alongside `/to-issues` (i.e. the PRD is the source for a set of issues), the issues created by `/to-issues` will be transitioned to `ready-for-agent` per that skill's own flow (Matt's "no additional triage" pattern is preserved at the issue level, not the PRD level).
```

- [ ] **Step 3: Verify the body**

```bash
grep -nE "create PRD page|read glossary|read ADRs in area" skills/engineering/to-prd/SKILL.md
```
Expected: each appears at least once.

```bash
grep -niE "gh issue|github issue|setup-matt-pocock-skills|matt[ -]?pocock|vitest|jest|pytest|junit" skills/engineering/to-prd/SKILL.md
```
Expected: no output.

- [ ] **Step 4: Commit**

```bash
git add skills/engineering/to-prd/SKILL.md
git commit -m "feat(to-prd): use create-PRD-page verb; preserve ready-for-agent at the issue level"
```

---

## Task 8: Customize `/improve-codebase-architecture`

**Files:**
- Modify: `skills/engineering/improve-codebase-architecture/SKILL.md`

This skill has the most stale references — frontmatter description mentions `CONTEXT.md` and `docs/adr/`, body line ~78 says "Add the term to `CONTEXT.md`", line ~80 cross-references `../grill-with-docs/CONTEXT-FORMAT.md`, line ~64 says "Use CONTEXT.md vocabulary". All need verb substitutions.

- [ ] **Step 1: Update the frontmatter description**

Open `skills/engineering/improve-codebase-architecture/SKILL.md`. Find the description line in the frontmatter:

```
description: Find deepening opportunities in a codebase, informed by the domain language in CONTEXT.md and the decisions in docs/adr/. Use when the user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, or make a codebase more testable and AI-navigable.
```

Replace with:

```
description: Find deepening opportunities in a codebase, informed by the project's domain glossary and architectural decisions (loaded via tracker-primitives). Use when the user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, or make a codebase more testable and AI-navigable.
```

- [ ] **Step 2: Add a verbs preamble**

After the first paragraph of the body (ending "The aim is testability and AI-navigability."), insert:

````markdown
## Verbs used

- `read glossary` — to learn the canonical names for modules, seams, and concepts before proposing renames
- `read ADRs in area` — to avoid suggesting refactors that an ADR forbids
- `write glossary entry` — when a deepened module needs a new canonical name
- `create ADR` — when the user rejects a candidate for a non-obvious, durable reason

Backend-specific MCP / CLI mappings live in `../tracker-primitives/<backend>.md`.
````

- [ ] **Step 3: Rewrite the "Explore" step's first line**

Find:

```
Read the project's domain glossary and any ADRs in the area you're touching first.
```

Replace with:

```
Before exploring, invoke `read glossary` and `read ADRs in area` to load the canonical vocabulary and respect documented decisions.
```

- [ ] **Step 4: Rewrite the "Use CONTEXT.md vocabulary" instruction**

Find:

```
**Use CONTEXT.md vocabulary for the domain, and [LANGUAGE.md](LANGUAGE.md) vocabulary for the architecture.** If `CONTEXT.md` defines "Order," talk about "the Order intake module" — not "the FooBarHandler," and not "the Order service."
```

Replace with:

```
**Use the project's domain glossary vocabulary for the domain, and [LANGUAGE.md](LANGUAGE.md) vocabulary for the architecture.** If the glossary defines "Order," talk about "the Order intake module" — not "the FooBarHandler," and not "the Order service."
```

- [ ] **Step 5: Rewrite the side-effect lines under "Grilling loop"**

Find:

```
- **Naming a deepened module after a concept not in `CONTEXT.md`?** Add the term to `CONTEXT.md` — same discipline as `/grill-with-docs` (see [CONTEXT-FORMAT.md](../grill-with-docs/CONTEXT-FORMAT.md)). Create the file lazily if it doesn't exist.
- **Sharpening a fuzzy term during the conversation?** Update `CONTEXT.md` right there.
- **User rejects the candidate with a load-bearing reason?** Offer an ADR, framed as: _"Want me to record this as an ADR so future architecture reviews don't re-suggest it?"_ Only offer when the reason would actually be needed by a future explorer to avoid re-suggesting the same thing — skip ephemeral reasons ("not worth it right now") and self-evident ones. See [ADR-FORMAT.md](../grill-with-docs/ADR-FORMAT.md).
```

Replace with:

```
- **Naming a deepened module after a concept not in the glossary?** Invoke `write glossary entry` for the new term — same discipline as `/grill-with-docs` (see [CONTEXT-FORMAT.md](../grill-with-docs/CONTEXT-FORMAT.md) for the page-body shape).
- **Sharpening a fuzzy term during the conversation?** Invoke `write glossary entry` right there (use `mcp__notion__notion-update-page` for the matching page if one already exists).
- **User rejects the candidate with a load-bearing reason?** Offer an ADR via `create ADR`, framed as: _"Want me to record this as an ADR so future architecture reviews don't re-suggest it?"_ Only offer when the reason would actually be needed by a future explorer to avoid re-suggesting the same thing — skip ephemeral reasons ("not worth it right now") and self-evident ones. See [ADR-FORMAT.md](../grill-with-docs/ADR-FORMAT.md) for the page-body shape.
```

- [ ] **Step 6: Verify no literal `CONTEXT.md` or `docs/adr/` references survive in this skill's body**

```bash
grep -nE "CONTEXT\\.md|docs/adr/" skills/engineering/improve-codebase-architecture/SKILL.md
```
Expected: no output. (The cross-skill links to `../grill-with-docs/CONTEXT-FORMAT.md` and `ADR-FORMAT.md` are different paths — they should still appear and are correct.)

```bash
grep -nE "../grill-with-docs/CONTEXT-FORMAT\\.md|../grill-with-docs/ADR-FORMAT\\.md" skills/engineering/improve-codebase-architecture/SKILL.md
```
Expected: both appear.

- [ ] **Step 7: Verify abstract verbs are used**

```bash
grep -nE "read glossary|read ADRs in area|write glossary entry|create ADR" skills/engineering/improve-codebase-architecture/SKILL.md
```
Expected: each verb appears at least once.

- [ ] **Step 8: Verify supporting files exist**

```bash
for f in LANGUAGE.md HTML-REPORT.md INTERFACE-DESIGN.md; do
  test -s "skills/engineering/improve-codebase-architecture/$f" && echo "OK: $f" || echo "MISSING: $f"
done
```
Expected: 3 OK lines.

- [ ] **Step 9: Verify the HTML-report path remains $TMPDIR-based**

```bash
grep -n "TMPDIR" skills/engineering/improve-codebase-architecture/SKILL.md
```
Expected: at least one match (the existing Phase 2 instructions reference `$TMPDIR`).

- [ ] **Step 10: Commit**

```bash
git add skills/engineering/improve-codebase-architecture/
git commit -m "feat(improve-codebase-architecture): use abstract verbs; drop literal CONTEXT.md/docs/adr refs"
```

---

## Task 9: Verify `/zoom-out` (1-liner unchanged)

**Files:**
- Verify only: `skills/engineering/zoom-out/SKILL.md`

Per the grill (Q9), `/zoom-out` ships as its existing 1-liner. The spec §6.2 phrase "loads supporting refs (modules map, callers index)" was stripped in Task 1 Step 4.

- [ ] **Step 1: Confirm the body is a 1-liner**

```bash
test "$(wc -l < skills/engineering/zoom-out/SKILL.md)" -le 8 && echo "1-liner OK"
```
Expected: `1-liner OK`. (Frontmatter is ~5 lines; body is 1 line; total should be ≤8.)

```bash
cat skills/engineering/zoom-out/SKILL.md
```
Read the file and confirm:
- Frontmatter has `disable-model-invocation: true`
- The body says nothing about loading supporting refs / modules map / callers index
- The body uses "project's domain glossary vocabulary"

- [ ] **Step 2: Verify hygiene**

```bash
grep -niE "matt[ -]?pocock|setup-matt-pocock-skills|gh issue|vitest|jest|pytest|junit" skills/engineering/zoom-out/SKILL.md
```
Expected: no output.

If everything is clean, no commit needed for this task.

---

## Task 10: Customize `/handoff`

**Files:**
- Modify: `skills/engineering/handoff/SKILL.md`

This is the biggest body change in Stage 2 — `/handoff` currently writes to `$TMPDIR`; it must move to invoking `create handoff page` against the per-repo Handoffs DB, set the `Epic` column at invocation, and use the canonical section order.

- [ ] **Step 1: Replace the entire SKILL.md body**

Overwrite `skills/engineering/handoff/SKILL.md` with this content:

````markdown
---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up. Writes to the per-repo Handoffs DB with the workstream's Epic tag.
argument-hint: "What will the next session be used for?"
---

# Handoff

Write a handoff document so a fresh agent can resume this work in a later session. The document lives in the per-repo Handoffs DB; each handoff is tagged with the **Epic** it belongs to (the workstream / feature track within this project).

## Verbs used

- `create handoff page` — writes the handoff to the Handoffs DB
- `read glossary` (optional) — only if a term used in the handoff needs a canonical-vocabulary check

Backend-specific MCP / CLI mappings live in `../tracker-primitives/<backend>.md`.

## Process

### 1. Pick the Epic

Before composing the body, ask which **Epic** this handoff belongs to:

- Read the Handoffs DB's `Epic` property options (via `mcp__notion__notion-fetch` on the Handoffs DB ID from `docs/agents/notion.md`).
- Present the existing options as a single AskUserQuestion. Default to the most recently used option if context suggests it (e.g. an in-progress Epic that's been written to today).
- If no existing option fits, offer "Add a new Epic" — when picked, ask for the new Epic name. Read the current option list, append the new option, and call `mcp__notion__notion-update-data-source` with `ALTER COLUMN "Epic" SET SELECT(...)` listing all existing options **plus** the new one. (ALTER COLUMN replaces the option list wholesale; do not use ADD COLUMN — that adds a new property, not a new option.)

### 2. Compose the body

Use the **canonical section order**:

1. **Goal** — what the next session should accomplish.
2. **What's done** — a tight list of what's already in place. Do not duplicate content already captured in PRDs, plans, ADRs, issues, commits, or diffs — reference them by path/URL instead.
3. **Open questions** — decision points the next session must resolve. Each one names what's at stake and what's blocking it.
4. **Suggested skills** — which engineering / productivity skills the next session should invoke, in expected order. Always mention `superpowers:brainstorming` for design exploration if the open questions are design-shaped; mention `/grill-with-docs` for stress-testing against the project's existing domain artifacts; mention this skill's own write-up tools (`/to-prd`, `/to-issues`, `/triage`) only if downstream conversion is part of the plan.
5. **Key files** — paths the next session will need to read first. Spec docs, recent plans, in-flight skill bodies, the relevant tracker-primitives recipe. Keep it short.
6. **Sensitive-info note** — explicit statement about what's redacted and what isn't. API keys, credentials, PII, internal-only repo paths — these never go into the handoff body. If there's nothing sensitive, say "None — all referenced material is repo-internal or workspace-public."

If the user passed arguments to the slash command, treat them as a description of what the next session will focus on and tailor the Goal accordingly.

### 3. Confirm and write

Show the drafted body to the user before invoking `create handoff page`. If they edit it, accept the edit. Then invoke `create handoff page`:

- Parent: Handoffs DB ID from `docs/agents/notion.md`
- Title: short slug summarizing the handoff (e.g. "Stage 2 publish blocker — productivity tile scaffold")
- Properties: `Name` (title), `Date` (today), `Epic` (the value chosen in step 1)
- Body: the composed sections from step 2

If the Notion MCP call fails (auth, missing DB, schema mismatch), stop and tell the user — do not fall back to writing a file. (Stage 1's `/grill-with-docs` failure mode is the same.)

### 4. Confirm

Tell the user the Handoffs DB page URL so they can reference it from the next session.
````

- [ ] **Step 2: Verify the body**

```bash
grep -nE "create handoff page|Epic|Goal|What's done|Open questions|Suggested skills|Key files|Sensitive-info note" skills/engineering/handoff/SKILL.md
```
Expected: each phrase appears at least once.

```bash
grep -niE "temporary directory|/tmp|\\\$TMPDIR" skills/engineering/handoff/SKILL.md
```
Expected: no output. (No more temp-file path; everything goes to the Handoffs DB.)

```bash
grep -niE "matt[ -]?pocock|setup-matt-pocock-skills" skills/engineering/handoff/SKILL.md
```
Expected: no output.

- [ ] **Step 3: Commit**

```bash
git add skills/engineering/handoff/SKILL.md
git commit -m "feat(handoff): write to per-repo Handoffs DB with Epic tag and canonical section order"
```

---

## Task 11: Customize `/grill-me`

**Files:**
- Modify: `skills/productivity/grill-me/SKILL.md`

Per spec §6.2: `/grill-me` is non-code grilling — design / strategy / plans / talks with no codebase to read against. The body must make the non-overlap with `/grill-with-docs` explicit so the agent picks the right tool.

- [ ] **Step 1: Read the current body**

```bash
cat skills/productivity/grill-me/SKILL.md
```

Identify whether the body already scopes itself to non-code. If yes, the change is light (one explicit non-overlap line). If no, the change is heavier (full scope statement).

- [ ] **Step 2: Add the scope statement near the top of the body**

After the frontmatter, insert (or replace the existing first paragraph with) this block:

````markdown
This skill is for **non-code grilling** — designs, strategies, plans, talks, and other artifacts where there is no codebase to read against. The point of the grilling is the user's own thinking, not domain alignment against a repository.

If the artifact you want to grill has a codebase or existing domain documentation (glossary, ADRs), use [`/grill-with-docs`](../../engineering/grill-with-docs/SKILL.md) instead — that skill grounds the conversation in the project's existing terminology and architectural decisions before challenging the new idea.
````

The rest of the body (the actual grilling instructions) stays as-is.

- [ ] **Step 3: Verify**

```bash
grep -niE "non-code grilling|grill-with-docs" skills/productivity/grill-me/SKILL.md
```
Expected: both phrases appear.

```bash
grep -niE "matt[ -]?pocock|setup-matt-pocock-skills" skills/productivity/grill-me/SKILL.md
```
Expected: no output.

- [ ] **Step 4: Commit**

```bash
git add skills/productivity/grill-me/SKILL.md
git commit -m "feat(grill-me): scope to non-code grilling; cross-reference grill-with-docs"
```

---

## Task 12: Verify `/caveman` and `/write-a-skill` (unchanged)

**Files:**
- Verify only: `skills/productivity/caveman/SKILL.md`, `skills/productivity/write-a-skill/SKILL.md` (+ their supporting files)

Both ship unchanged per spec §6.2. This task is hygiene-only.

- [ ] **Step 1: Hygiene grep for both skills**

```bash
grep -rniE "setup-matt-pocock-skills|matt[ -]?pocock|gh issue|github issue|vitest|jest|pytest|junit|mocha|jasmine|karma" \
  skills/productivity/caveman/ \
  skills/productivity/write-a-skill/
```
Expected: no output.

If anything turns up, neutralize inline and commit a fix. Otherwise, no commit.

- [ ] **Step 2: Verify referenced supporting files exist**

```bash
ls skills/productivity/caveman/SKILL.md
ls skills/productivity/write-a-skill/
```
Confirm SKILL.md is present in each, and any files referenced from those SKILL.md bodies also exist (read each SKILL.md briefly to spot link references; verify each link target exists).

---

## Task 13: Cross-cutting hygiene

**Files:**
- Rewrite: `README.md` (top-level)
- Rewrite: `skills/engineering/README.md` (drop Stage 1 / Stage 2 split)
- Verify: `skills/productivity/README.md` (already matches the 3-skill productivity bucket post-Stage 1)

- [ ] **Step 1: Rewrite the top-level README**

Overwrite `/Users/Home/Development/skills/README.md` with this content:

````markdown
# Bonai Skills

A personal, Notion-first set of agent skills I use every day. Packaged as two private tessl tiles under the `bonai-dev` workspace; both ship at the same year.month.day calver.

| Tile | Skills | Latest |
|---|---|---|
| [`bonai-dev/engineering-skills`](./skills/engineering/) | Daily code-work skills (setup, TDD, diagnosis, grilling, prototyping, triage, handoff, PRD/issue conversion, architecture review, zoom-out) | `YYYY.M.D` |
| [`bonai-dev/productivity-skills`](./skills/productivity/) | General workflow skills (caveman compression, non-code grilling, skill authoring) | `YYYY.M.D` |

Skills lean on the agent to interrogate the user (via `AskUserQuestion`-style flows) rather than prescribing rigid checklists. The set replaces my prior use of the `superpowers` plugin — bonai is standalone and has no superpowers fallback.

## Layout

```
skills/
  engineering/        ← daily code work (tile: bonai-dev/engineering-skills)
    tracker-primitives/ ← shared MCP/CLI recipes for the abstract-verb contract
  productivity/       ← daily non-code workflow (tile: bonai-dev/productivity-skills)
  misc/               ← kept around but rarely used
  personal/           ← tied to my own setup, not promoted
  in-progress/        ← drafts not yet ready to ship
  deprecated/         ← no longer used
```

## How to install (consumer side)

In a target repo:

```sh
tessl install bonai-dev/engineering-skills@YYYY.M.D
tessl install bonai-dev/productivity-skills@YYYY.M.D
```

Then run the setup skill once per repo:

```
/setup-bonai-skills
```

This writes `docs/agents/commands.md` (canonical test/lint/typecheck/build commands) and `docs/agents/notion.md` (the 5 Notion database IDs and property mappings, including the Handoffs DB's `Epic` select column). Engineering skills read these to stay language-agnostic and tracker-agnostic. The productivity tile is zero-config — no per-repo setup required.

## The abstract-verb contract

Skill bodies use only **abstract verbs** — never concrete tool calls. `skills/engineering/tracker-primitives/` translates each verb to the chosen backend (Notion, GitHub, or local markdown). Per-repo IDs live in `docs/agents/notion.md` (or equivalent). See [`tracker-primitives/README.md`](./skills/engineering/tracker-primitives/README.md) for the controlled vocabulary (10 verbs).

## Skills

### Engineering (11)

- [`setup-bonai-skills`](./skills/engineering/setup-bonai-skills/SKILL.md) — per-repo config scaffolding
- [`tdd`](./skills/engineering/tdd/SKILL.md) — test-driven development loop
- [`diagnose`](./skills/engineering/diagnose/SKILL.md) — disciplined bug-diagnosis loop
- [`grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) — grilling that writes glossary / ADRs inline
- [`prototype`](./skills/engineering/prototype/SKILL.md) — throwaway prototype for logic or UI questions
- [`triage`](./skills/engineering/triage/SKILL.md) — issue triage state machine; posts agent briefs as child pages
- [`to-issues`](./skills/engineering/to-issues/SKILL.md) — break a plan into independently-grabbable issues
- [`to-prd`](./skills/engineering/to-prd/SKILL.md) — synthesize current context into a PRD
- [`improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) — find deepening opportunities, HTML-report-driven
- [`zoom-out`](./skills/engineering/zoom-out/SKILL.md) — higher-level perspective on unfamiliar code
- [`handoff`](./skills/engineering/handoff/SKILL.md) — cross-session handoff documents, written to the Handoffs DB with an Epic tag

### Productivity (3)

- [`caveman`](./skills/productivity/caveman/SKILL.md) — ultra-compressed communication mode
- [`grill-me`](./skills/productivity/grill-me/SKILL.md) — non-code interrogation about a plan / design / talk
- [`write-a-skill`](./skills/productivity/write-a-skill/SKILL.md) — produce a new skill folder (tile-agnostic)

## License

MIT — see [LICENSE](./LICENSE).
````

- [ ] **Step 2: Rewrite `skills/engineering/README.md`**

Overwrite with this content (drops the Stage 1 / Stage 2 split — all 11 skills now ship in the engineering tile):

````markdown
# Engineering

Skills for daily code work. All 11 skills below are in the `bonai-dev/engineering-skills` tile manifest at the current `YYYY.M.D` calver.

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
````

- [ ] **Step 3: Verify the productivity bucket README matches the 3-skill productivity tile**

Read `skills/productivity/README.md` and confirm it lists exactly: `caveman`, `grill-me`, `write-a-skill`. (Stage 1 already removed `handoff` from this bucket; this is a sanity check.)

```bash
grep -E "^\- \*\*\[" skills/productivity/README.md | wc -l
```
Expected: 3.

If the count is wrong, fix the file. (Out of scope: re-adding `handoff` here.)

- [ ] **Step 4: Verify the top-level repo hygiene**

```bash
grep -rniE "setup-matt-pocock-skills|matt[ -]?pocock" \
  README.md skills/engineering/README.md skills/productivity/README.md
```
Expected: no output.

- [ ] **Step 5: Commit**

```bash
git add README.md skills/engineering/README.md skills/productivity/README.md
git commit -m "chore: rebrand READMEs for Stage 2 two-tile completion"
```

---

## Task 14: Scaffold the productivity tile

**Files:**
- Create: `tiles/productivity-skills/tile.json` (via MCP tool)

- [ ] **Step 1: Confirm tessl auth + workspace**

Run `mcp__tessl__status`. Expected: shows workspace `bonai-dev` authenticated and `bonai-dev/engineering-skills@2026.5.0` in sync.

- [ ] **Step 2: Check whether the productivity tile already exists**

Call `mcp__tessl__search` for `bonai-dev/productivity-skills`. Two outcomes:

- **Tile does not exist** → proceed to Step 3.
- **Tile already exists** (e.g. from a prior aborted Stage 2 run) → skip Step 3. If `tiles/productivity-skills/tile.json` already exists locally, re-use it and jump to Step 5.

- [ ] **Step 3: Scaffold the productivity tile**

Call `mcp__tessl__new_tile` with workspace `bonai-dev`, name `productivity-skills`, visibility `private`, initial version `YYYY.M.D` (the day of intended publish — see Task 18 Step 1 for how to lock in the value).

If the tool requires additional fields:
- description: `Productivity skills for non-code workflow — caveman compression, non-code grilling, skill authoring`
- license: leave default

Expected: file appears at `tiles/productivity-skills/tile.json`.

- [ ] **Step 4: Capture the scaffolded schema**

```bash
cat tiles/productivity-skills/tile.json
```
Note the field shape (especially the skills field — Task 16 must match).

- [ ] **Step 5: Commit the scaffold**

```bash
git add tiles/productivity-skills/tile.json
git commit -m "chore: scaffold bonai-dev/productivity-skills tile"
```

---

## Task 15: Populate engineering tile manifest

**Files:**
- Modify: `tiles/engineering-skills/tile.json`

Add the 6 Stage 2 skills (keep the 5 Stage 1 skills) and bump the version to `YYYY.M.D`.

- [ ] **Step 1: Re-read the existing tile.json**

```bash
cat tiles/engineering-skills/tile.json
```
Confirm the current version is `2026.5.0` and the skills list contains exactly the 5 Stage 1 skill paths.

- [ ] **Step 2: Update version and skills list**

Edit `tiles/engineering-skills/tile.json`:
- Change `version` from `2026.5.0` to `YYYY.M.D` (literal placeholder; Task 18 Step 1 substitutes the actual day).
- Add 6 new entries to the skills list (paths must match Stage 2 skill folder locations):

```
"./skills/engineering/triage"
"./skills/engineering/to-issues"
"./skills/engineering/to-prd"
"./skills/engineering/improve-codebase-architecture"
"./skills/engineering/zoom-out"
"./skills/engineering/handoff"
```

Translate to whatever shape the scaffold uses (array of strings vs array of objects with `path` keys etc — match what's already there).

- [ ] **Step 3: Verify the 11-skill manifest matches `.claude-plugin/plugin.json`**

```bash
grep -oE '\./skills/engineering/[a-z-]+' tiles/engineering-skills/tile.json | sort -u
grep -oE '\./skills/engineering/[a-z-]+' .claude-plugin/plugin.json | sort -u
```
Expected: identical sets (11 engineering skill paths each). `plugin.json` also lists the 3 productivity skills — those are extra and expected.

- [ ] **Step 4: Commit**

```bash
git add tiles/engineering-skills/tile.json
git commit -m "feat: extend engineering tile manifest to all 11 customized skills"
```

---

## Task 16: Populate productivity tile manifest

**Files:**
- Modify: `tiles/productivity-skills/tile.json`

- [ ] **Step 1: Edit tile.json to list the 3 productivity skills**

```
./skills/productivity/caveman
./skills/productivity/grill-me
./skills/productivity/write-a-skill
```

Match the schema captured in Task 14 Step 4.

- [ ] **Step 2: Verify**

```bash
grep -oE '\./skills/productivity/[a-z-]+' tiles/productivity-skills/tile.json | sort -u
```
Expected: exactly the 3 paths above.

- [ ] **Step 3: Commit**

```bash
git add tiles/productivity-skills/tile.json
git commit -m "feat: populate productivity tile manifest with caveman, grill-me, write-a-skill"
```

---

## Task 17: Local validation in a scratch repo

> **User-driven task.** Jay runs these steps interactively — they require live Claude Code sessions, real Notion writes against `bonai-dev`, and judgment calls a non-interactive executor cannot make.

Exercises both tiles end-to-end before publishing.

- [ ] **Step 1: Create a scratch repo**

```bash
mkdir -p /tmp/bonai-stage2-validate && cd /tmp/bonai-stage2-validate && git init && echo "# scratch" > README.md && git add . && git commit -m "init"
```

- [ ] **Step 2: Install both tiles locally**

Use `mcp__tessl__install` with each local tile path (or however the tessl MCP supports installing un-published tiles). If un-published install isn't supported, follow the same defer-to-post-publish pattern as Stage 1 Task 14 Step 2.

Expected: 11 engineering skills + 3 productivity skills appear under the scratch repo's `.claude/` (or wherever tessl vendors them).

- [ ] **Step 3: Run `/setup-bonai-skills`**

In a Claude Code session against `/tmp/bonai-stage2-validate`, run `/setup-bonai-skills`. Use the `bonai-dev` workspace; create throwaway DBs for the 5 databases — including the Handoffs DB with the new `Epic` select column.

Verify:
```bash
grep -q "Epic" /tmp/bonai-stage2-validate/docs/agents/notion.md && echo "Epic in notion.md OK"
```
Expected: `Epic in notion.md OK`.

- [ ] **Step 4: Smoke-test `/triage`**

Create a sample issue in the scratch repo's Issues DB (manually or via `/to-issues`). Invoke `/triage` and ask it to triage that issue. Verify:
- The agent invokes `transition state` (visible in the Notion DB update).
- If the triage outcome is `ready-for-agent`, a child page named "Agent brief: …" appears under the issue page in Notion (via `post agent brief`).
- The body uses no `gh issue` / `apply label` / `add label` phrasing.

- [ ] **Step 5: Smoke-test `/to-issues`**

Provide a small plan (3 vertical slices) and invoke `/to-issues`. Verify:
- 3 issues land in the Issues DB.
- Each is created with Status = `needs-triage` (seed default) and then transitioned to `ready-for-agent` (visible in the property history or current value).
- The dependency relation (`Blocked by`) points to the right page IDs for any slice that depends on another.

- [ ] **Step 6: Smoke-test `/to-prd`**

Have a short discussion with the agent about a hypothetical small feature. Invoke `/to-prd`. Verify:
- A new PRD page appears in the PRDs DB with the canonical structure (Problem / Solution / User Stories / Implementation Decisions / Testing Decisions / Out of Scope / Further Notes).
- The PRD references domain-glossary terms when relevant.

- [ ] **Step 7: Smoke-test `/improve-codebase-architecture`**

Use the scratch repo's tiny code (or point the skill at a slightly larger demo project if `/tmp/bonai-stage2-validate` is too sparse). Verify:
- The HTML report is written under `$TMPDIR` (not in the scratch repo).
- The report uses glossary vocabulary, not literal `CONTEXT.md` references.
- If the conversation produces a new canonical term, the skill invokes `write glossary entry` (a new page appears in the Domain Glossary DB).

- [ ] **Step 8: Smoke-test `/zoom-out`**

Type `/zoom-out we are doing X, focus on Y` in a session. Verify the agent re-aligns to the user-prefix and uses domain-glossary vocabulary in its response. (The 1-liner skill body should not constrain the agent away from realignment-style usage.)

- [ ] **Step 9: Smoke-test `/handoff`**

Invoke `/handoff` in an active session. Verify:
- The agent presents existing `Epic` options from the Handoffs DB and lets the user pick.
- A new page appears in the Handoffs DB with the canonical section order (Goal / What's done / Open questions / Suggested skills / Key files / Sensitive-info note) and the chosen `Epic` value.
- Nothing lands in `$TMPDIR` (no temp-file fallback).

- [ ] **Step 10: Smoke-test `/grill-me`**

Invoke `/grill-me` against a non-code artifact (e.g. a plan or talk outline). Verify the skill body asserts it's non-code grilling and offers `/grill-with-docs` as the alternative for code-backed grilling.

- [ ] **Step 11: Smoke-test `/caveman` and `/write-a-skill`**

Invoke each briefly to confirm they load and run as before. No behavioural change expected.

- [ ] **Step 12: If any smoke test fails, fix inline**

Treat each failure as a bug in the corresponding skill body. Fix, re-run, then continue. Do not proceed to Task 18 until all 9 functional smoke tests (Steps 4–11; Step 11 = 2 skills) are green.

- [ ] **Step 13: Clean up**

Archive or delete the throwaway Notion DBs created in Step 3. Remove the scratch repo:
```bash
rm -rf /tmp/bonai-stage2-validate
```

If Step 12 produced fixes, stage and commit them:
```bash
git -C /Users/Home/Development/skills add -A
git -C /Users/Home/Development/skills commit -m "fix(stage2): address issues found during scratch-repo validation"
```

---

## Task 18: Publish both tiles at YYYY.M.D

> **User-driven task.** One-way action. An automated executor should not run `tessl tile publish` autonomously.

- [ ] **Step 1: Lock in the calver date**

Determine today's date (the publish day) and substitute it into both `tile.json` files in `YYYY.M.D` form (no zero-padding — e.g. `2026.5.26`, not `2026.05.26`):

```bash
DATE=$(date +%Y.%-m.%-d)
echo "Publishing as $DATE"
```

Edit `tiles/engineering-skills/tile.json` and `tiles/productivity-skills/tile.json`: change the `version` field from the `YYYY.M.D` placeholder to the actual value. Also update the README and bucket README references to the placeholder (e.g. `YYYY.M.D` in README.md) — search-and-replace those to the same actual value.

Commit:
```bash
git add tiles/ README.md skills/engineering/README.md
git commit -m "chore: lock calver to $DATE for Stage 2 publish"
```

- [ ] **Step 2: Confirm working tree is clean**

```bash
git status
```
Expected: clean working tree.

- [ ] **Step 3: Dry-run + publish engineering tile**

```bash
tessl tile lint tiles/engineering-skills
tessl tile pack tiles/engineering-skills
tessl tile publish --dry-run tiles/engineering-skills
```
Read each output; confirm no validation errors.

Then publish for real:
```bash
tessl tile publish tiles/engineering-skills
```

Prerequisites:
- `tessl status` shows `bonai-dev` authenticated.
- Jay has owner role on `bonai-dev`.
- `tile.json` declares `workspace: bonai-dev`, `version: <YYYY.M.D from Step 1>`.

- [ ] **Step 4: Dry-run + publish productivity tile**

```bash
tessl tile lint tiles/productivity-skills
tessl tile pack tiles/productivity-skills
tessl tile publish --dry-run tiles/productivity-skills
tessl tile publish tiles/productivity-skills
```

- [ ] **Step 5: Confirm via `mcp__tessl__status`**

Call `mcp__tessl__status`. Expected: both tiles in sync at the Step 1 calver date.

- [ ] **Step 6: Install from the published tiles in a fresh scratch repo**

```bash
mkdir -p /tmp/bonai-stage2-postpublish && cd /tmp/bonai-stage2-postpublish && git init
```

Call `mcp__tessl__install` for `bonai-dev/engineering-skills@<DATE>` and `bonai-dev/productivity-skills@<DATE>`. Expected: both installs succeed; 11 + 3 skills available.

- [ ] **Step 7: Clean up**

```bash
rm -rf /tmp/bonai-stage2-postpublish
```

- [ ] **Step 8: Tag the releases locally**

```bash
git tag engineering-skills-v<DATE>
git tag productivity-skills-v<DATE>
```

(Push tags only if the user asks.)

- [ ] **Step 9: Announce done**

Summarize for the user:
- `bonai-dev/engineering-skills` re-published at `<DATE>`, private (11 skills).
- `bonai-dev/productivity-skills` first published at `<DATE>`, private (3 skills).
- Map each acceptance criterion (below) to its verification task; confirm each box.
- Bonai now fully replaces `superpowers` — the consumer can `tessl install` both tiles and drop the superpowers plugin from any repo's `.claude-plugin/`.

---

## Acceptance criteria (Stage 2)

Verify each before declaring Stage 2 done. Each line maps to the task(s) that satisfy it.

- [ ] `mcp__tessl__status` shows `bonai-dev/engineering-skills` in sync at `YYYY.M.D` and `bonai-dev/productivity-skills` at `YYYY.M.D` (year.month.day of publish) — **Task 18 Step 5**.
- [ ] `tessl install bonai-dev/engineering-skills@YYYY.M.D` and `tessl install bonai-dev/productivity-skills@YYYY.M.D` succeed in a scratch repo — **Task 18 Step 6**.
- [ ] The engineering tile manifest contains 11 customized engineering skills (Stage 1's 5 + Stage 2's 6: `triage`, `to-issues`, `to-prd`, `improve-codebase-architecture`, `zoom-out`, `handoff`) — **Task 15 Step 3**.
- [ ] The productivity tile manifest contains 3 productivity skills (`caveman`, `grill-me`, `write-a-skill`) — **Task 16 Step 2**.
- [ ] `tracker-primitives/README.md` controlled vocabulary table adds `post agent brief`; `/tdd` and `/diagnose` are removed from the table rows — **Tasks 2 Step 1 + 3 Step 3**.
- [ ] `tracker-primitives/notion.md` has a `post agent brief` recipe creating a child page of the issue page — **Task 2 Step 2**.
- [ ] `/triage` body uses abstract verbs (`transition state`, `post triage note`, `post agent brief`, `create issue page`, `read glossary`, `read ADRs in area`) — no `gh issue`, `label`, or `comment` phrasing — **Task 5 Step 4**.
- [ ] `/to-issues` uses `create issue page`, sets Status to `ready-for-agent` at creation (Matt's skip-triage pattern), and links blocking issues via the `Blocked by` relation — **Task 6 Step 3 + Task 17 Step 5**.
- [ ] `/to-prd` uses `create PRD page` and applies the `ready-for-agent` triage marker at the issue level — **Task 7 Step 3**.
- [ ] `/improve-codebase-architecture` uses `read glossary`, `write glossary entry`, `read ADRs in area`, `create ADR`; HTML report writes to `$TMPDIR`; body has no literal `CONTEXT.md` / `docs/adr/` references — **Task 8 Steps 6 + 9**.
- [ ] `/zoom-out` body remains a 1-liner — no supporting-refs loading — **Task 9 Step 1**.
- [ ] `/handoff` writes to the per-repo Handoffs DB with an `Epic` select value chosen at invocation, body uses the canonical Goal / What's done / Open questions / Suggested skills / Key files / Sensitive-info note section order — **Task 10 Step 2 + Task 17 Step 9**.
- [ ] `/grill-me` body explicitly scopes itself to non-code grilling and cross-references `/grill-with-docs` — **Task 11 Step 3**.
- [ ] `/caveman` and `/write-a-skill` ship unchanged — **Task 12 Step 1**.
- [ ] Every Stage 2 customized skill body contains zero references to `setup-matt-pocock-skills`, `matt-pocock`, `gh issue`, or specific test runners by name — **Tasks 5, 6, 7, 8, 10, 11 verification steps + Task 12 Step 1**.
- [ ] No `setup-productivity-skills` skill exists (zero-config productivity tile) — verifiable by `ls skills/engineering/ skills/productivity/ | grep -i productivity` — **Task 14** (productivity scaffold creates only `tile.json`, no setup skill).
- [ ] Spec sections updated to reflect the contract changes: §2 (calver shape → `YYYY.M.D`), §4.2 (vocabulary table adds `post agent brief`), §4.3 (Handoffs DB description mentions the Epic column), §6.2 (`/zoom-out` paragraph drops "loads supporting refs") — **Task 1 Steps 1–5**.

---

## Open items deferred to implementation

- **Exact `tile.json` schema for productivity** — Task 14 Step 4 captures the scaffold's actual schema; Task 16 adapts to it. (Mirrors Stage 1 Task 1's pattern.)
- **Whether un-published install works for both tiles** — Task 17 Step 2 falls back to the same defer-to-post-publish pattern as Stage 1 Task 14 Step 2.
- **Notion API behaviour for `ALTER COLUMN "Epic"` on an existing Handoffs DB** — Task 10's Step 1 flow includes "Add a new Epic" interactively, which rewrites the select-option list via ALTER COLUMN. If the wholesale-rewrite ALTER fails (option-name escaping, existing data-loss guard, auth scope), fall back to having the user add the option in the Notion UI and re-invoke `/handoff`.

---

## Out of scope for this plan

- Re-doing any Stage 1 work (`setup-bonai-skills`, `tdd`, `diagnose`, `grill-with-docs`, `prototype`, `tracker-primitives/` baseline, repo-wide matt-pocock → bonai rebrand, `.claude-plugin/plugin.json` skill list).
- Skills under `misc/`, `personal/`, `in-progress/`, `deprecated/`.
- Public tessl publishing — both tiles remain private.
- Migration tooling for existing repos' `CONTEXT.md` / `docs/adr/` into Notion DBs.
- A separate `bonai-dev/tracker-primitives` or `bonai-dev/skills-core` tile — primitives stay inside the engineering tile (Stage 2 grill Q1).
- Quarantine preamble / Trust Model README section / W011 active mitigation — grill walk-back; advisory accepted as-is.
- Evolution of `/zoom-out` into a full Agent.Explore-driven workflow — future-work, not Stage 2.
- Bonai-aware mode for `/write-a-skill` — stays tile-agnostic per spec §6.2.
