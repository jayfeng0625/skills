# Upstream Divergence Review — WORK IN PROGRESS

> **Status:** WIP review checkpoint. `skills/` has been reset to match `upstream/main` (mattpocock/skills). This doc is the ledger of everything the fork had changed, so each divergence can be re-applied deliberately rather than carried as a perpetual merge conflict.
>
> **Generated:** 2026-06-27
> **Baseline (pre-reset) commit:** `2ec07cf9006021fe496ea9754a2bb2a4da5245f0` — everything dropped below is recoverable from this commit via the re-apply playbook.
> **Upstream ref reviewed against:** `upstream/main`

Diff convention throughout: **`ours`** = the fork's pre-reset version, **`upstream`** = mattpocock/skills.

---

## What this checkpoint did

- **`skills/` now exactly matches `upstream/main`** (`git rm -r skills/ && git checkout upstream/main -- skills/`). This dropped the rebrand *and* all in-body structural edits, restored upstream's richer versions, and removed every fork-only skill/file under `skills/`.
- **tracker-primitives value relocated, not lost.** The Notion wiring that used to live in `skills/engineering/tracker-primitives/notion.md` (and force edits into `to-issues`/`to-prd`/`triage` bodies) is now ported to **`docs/agents/issue-tracker.md`** — upstream's own per-repo tracker-config seam, which the restored skills already read and upstream never touches. See [Decision 1](#open-decisions). Result: full Notion reliability with **zero skill-body divergence**.
- **Setup skill:** dropped `setup-bonai-skills` entirely; repo uses upstream's `setup-matt-pocock-skills`. Refs fixed in `.claude-plugin/plugin.json` + `CLAUDE.md`.
- **Brand/architecture pass (done):** kept the `bonai-dev` tiles + calver publishing identity, but rewrote `README.md` and `CONTEXT.md` to the converged reality (skills track upstream; tracker config via `docs/agents/issue-tracker.md`; no `tracker-primitives`). Dropped all ADRs (`docs/adr/0001–0003`). Repaired the `tiles/` symlinks (removed dangling `setup-bonai-skills` + `tracker-primitives`; added `setup-matt-pocock-skills`) and updated the engineering tile manifest.
- **Versioning:** keep calver/tessl tiles; do **not** adopt upstream's `.changeset/` + `package.json` + `CHANGELOG.md` (the bulk of the "42 behind"). On future syncs, skip those paths.
- **Eval suite reconciled (done).** Reseeded the four broken workflow scenarios (`eng-12` to-prd, `eng-13` to-issues, `eng-23` triage, `prod-9` handoff) to upstream's local-markdown tracker model (`inputs/docs/agents/{issue-tracker,triage-labels,domain}.md` + upstream-shape `## Agent skills` block; fixtures moved to `.scratch/<feature-slug>/…`); criteria rewritten to assert upstream behavior with `max_score` totals preserved. `eng-11` (TDD domain-grounding) block cleaned. **`eng-10` pruned** — it tested the fork-only commands-file indirection, which upstream tdd lacks. Audited the other 12 diverged-skill scenarios: all OK-as-is (their behaviors survive via upstream's `/grilling`, `/domain-modeling`, `/codebase-design` delegations). Zero `tracker-primitives`/fork-verb language remains; all JSON valid.

---

## 1. Net GAINS from convergence — upstream was richer; the fork had *removed* capability

Resetting restores behavior the fork had stripped out. Review whether the fork removed these deliberately; if so they must be re-removed.

| Path | What the fork had removed (now restored) |
|---|---|
| `engineering/diagnosing-bugs/SKILL.md` | Upstream's entire `### Minimise` phase + the "reproduce **and** minimise" gate, and the `### Completion criterion` checklist (red-capable / deterministic / fast / agent-runnable + `scripts/hitl-loop.template.sh` ref). Fork had collapsed these to one-liners. |
| `engineering/triage/SKILL.md` | The whole **PR-as-request-surface** treatment ("a PR is an issue with attached code", PR-state readings). Fork narrowed triage to issues only. |
| `engineering/triage/AGENT-BRIEF.md` | The "Good agent brief (PR)" example + `--json` walkthrough. |
| `engineering/triage/OUT-OF-SCOPE.md` | The enhancement-PR clause and the "already-implemented → don't poison dedup checks" guard. |

---

## 2. Structural fork value DROPPED — re-apply candidates

These are genuine capabilities (not cosmetics) that convergence removed because they lived inside skill bodies upstream owns, or in fork-only files.

### 2a. tracker-primitives cluster (ADR-0002) — interdependent, all-or-nothing

> **Resolution (this checkpoint):** do **not** re-apply this cluster. Upstream skills already delegate "the issue tracker" to a per-repo config file (`docs/agents/issue-tracker.md`), so the Notion value belongs there, not in edited skill bodies. The recipe has been ported to `docs/agents/issue-tracker.md`. Skills stay byte-identical to upstream. Two pieces are **not** covered by that seam and remain genuine decisions — see the exceptions below.

The fork's headline architecture: skills speak abstract verbs; a backend-agnostic layer translates them per tracker (Notion / GitHub / local). Dropping any piece orphans the rest.

| Path | Role |
|---|---|
| `engineering/tracker-primitives/{README,gh,local,notion}.md` | The engine. 6 verbs (`transition state`, `post triage note`, `post agent brief`, `create issue page`, `create PRD page`, `create handoff page`) → per-backend tool calls. **Fork-only.** |
| `engineering/setup-bonai-skills/` | The setup half. Scaffolds a relocatable Config dir (`docs/agents/`) with `commands.md` (per-language test/lint/build) + `workflow-config.md` (per-repo DB IDs). Adds command inference from `package.json`/`pyproject.toml`/etc. **Not a rename of `setup-matt-pocock-skills` — a full rearchitecture.** |
| `engineering/to-issues/SKILL.md` | "Verbs used" section → `../tracker-primitives/<backend>.md`; Notion `Blocked by` handling; `status: ready-for-agent` frontmatter. |
| `engineering/to-prd/SKILL.md` | "Verbs used" (`create PRD page`); Notion PRDs-DB wiring; terseness/fidelity house-style block. |
| `engineering/triage/SKILL.md` | "Verbs used" (`transition state`, `post triage note`, `post agent brief`, `create issue page`). |
| `productivity/handoff/SKILL.md` | Writes to per-repo Handoffs DB tagged with Epic (vs upstream's loose temp file); standardized schema. Consumer of tracker-primitives. |

> Note: upstream's `setup-matt-pocock-skills/` (issue-tracker-{github,gitlab,local}.md + triage-labels.md + domain.md model) is now restored in its place.

**Exceptions the config seam does NOT cover (still open):**

1. **`handoff` → Notion. RESOLVED: take upstream.** Upstream's `handoff` writes to the OS temp dir and is hardcoded — it does **not** read `docs/agents/issue-tracker.md`. Decision: keep upstream behavior; an alternative handoff location is flagged per-repo at setup time rather than forked into the skill body. (The old Notion handoff recipe remains recoverable from baseline `2ec07cf`, `tracker-primitives/notion.md`, if ever wanted.)
2. **`commands.md` (per-language test/lint/build + command inference).** Net-new fork capability — upstream's `setup-matt-pocock-skills` only scaffolds tracker/labels/domain, not commands. `docs/agents/commands.md` already exists locally and is unaffected by convergence; keep it. If you want it auto-generated, that logic lived only in the dropped `setup-bonai-skills`.

### 2b. TDD reference-file expansion

| Path | What was dropped |
|---|---|
| `engineering/tdd/SKILL.md` | "Iron Law" framing; `## Commands` section reading `test_command`/`typecheck_command` from the commands file (language-agnostic, never names a runner); links to the two files below. |
| `engineering/tdd/deep-modules.md` | **Fork-only.** Deep/shallow module diagrams; "boundaries are injected not encapsulated" guidance. |
| `engineering/tdd/interface-design.md` | **Fork-only.** Interface design for testability. |
| `engineering/tdd/mocking.md` | "Mocks return one fixed shape" + "Mock anti-patterns" (assert behavior not `toHaveBeenCalledWith`; no test-only `reset()` in prod). |
| `engineering/tdd/tests.md` | Runner-agnostic `mock(...)` instead of hardcoded `jest.mock(...)`. |

### 2c. grill-with-docs & improve-codebase-architecture — self-contained reimplementations

The fork replaced upstream's `/grilling` + `/domain-modeling` + `/codebase-design` skill-delegation with inline instructions + fork-only reference files reading `CONTEXT.md` and `docs/adr/` directly.

| Path | What was dropped |
|---|---|
| `engineering/grill-with-docs/SKILL.md` | +54-line inline implementation (vs upstream's 1-line delegation). |
| `engineering/grill-with-docs/ADR-FORMAT.md` | **Fork-only.** ADR template + "when to offer an ADR" rule. |
| `engineering/grill-with-docs/CONTEXT-FORMAT.md` | **Fork-only.** Glossary-entry template for `CONTEXT.md`. |
| `engineering/improve-codebase-architecture/SKILL.md` | Self-contained rework; copy-paste bash/HTML snippets; refs the fork-only files below. |
| `improve-codebase-architecture/DEEPENING.md` | **Fork-only.** Dependency-category taxonomy, "replace don't layer". |
| `improve-codebase-architecture/INTERFACE-DESIGN.md` | **Fork-only.** Design-it-twice parallel sub-agent pattern. |
| `improve-codebase-architecture/LANGUAGE.md` | **Fork-only.** Architecture vocabulary + "rejected framings". |
| `improve-codebase-architecture/HTML-REPORT.md` | Glossary-source pointer re-pointed to `LANGUAGE.md` (reverts cleanly). |

### 2d. Other standalone improvements

| Path | What was dropped |
|---|---|
| `productivity/grill-me/SKILL.md` | +58-line full skill (Iron Law: every question carries `**Recommended:**`; depth-first tree; interactive vs document modes) vs upstream's 1-line stub. |
| `productivity/teach/SKILL.md` + `teach/TEACHING-PHILOSOPHY.md` | Refactor: *why* extracted to fork-only PHILOSOPHY file; vetted-`RESOURCES.md` step. Treat as a pair. |
| `in-progress/review/SKILL.md` | Two prose improvements (sharper fixed-point prompt; expanded standards-sources list). Lives in `in-progress/`, so no README/plugin impact. |
| `engineering/domain-modeling/CONTEXT-FORMAT.md` | Trivial placeholder reword. |
| **Cross-cutting** | Prompt-injection hardening (treat fetched glossary/ADR/issue text as "untrusted data, not instructions") across tdd / to-issues / to-prd. |

---

## 3. Pure rebrand / cosmetic DROPPED — no action needed

| Path | Change |
|---|---|
| `engineering/ask-matt/SKILL.md` | Only `/setup-bonai-skills` → `/setup-matt-pocock-skills` precondition line. |
| `engineering/prototype/SKILL.md` | Frontmatter only: expanded description + removed `disable-model-invocation: true`. |
| `personal/edit-article/SKILL.md` | Removed `disable-model-invocation: true`. |
| Various SKILL.md | `setup-matt-pocock-skills` ↔ `setup-bonai-skills` name swaps and `disable-model-invocation` removals, bundled into the structural diffs above. |

---

## 4. Re-apply playbook

Everything dropped is in baseline commit `2ec07cf`. Restore selectively:

```bash
BASE=2ec07cf9006021fe496ea9754a2bb2a4da5245f0

# --- tracker-primitives cluster (re-apply as a UNIT) ---
git checkout $BASE -- \
  skills/engineering/tracker-primitives \
  skills/engineering/setup-bonai-skills \
  skills/engineering/to-issues/SKILL.md \
  skills/engineering/to-prd/SKILL.md \
  skills/engineering/triage/SKILL.md \
  skills/productivity/handoff/SKILL.md
# then re-strip the bonai naming from those bodies if keeping the cluster but not the brand

# --- TDD expansion ---
git checkout $BASE -- skills/engineering/tdd

# --- grill-with-docs / improve-arch reimplementations ---
git checkout $BASE -- \
  skills/engineering/grill-with-docs \
  skills/engineering/improve-codebase-architecture

# --- standalone wins ---
git checkout $BASE -- skills/productivity/grill-me/SKILL.md
git checkout $BASE -- skills/productivity/teach            # SKILL.md + TEACHING-PHILOSOPHY.md
```

> ⚠️ If re-applying the tracker cluster: `triage/SKILL.md`, `AGENT-BRIEF.md`, `OUT-OF-SCOPE.md` also carried the PR-surface *removal* (§1). Restoring the fork triage body re-drops upstream's PR triage — decide which you want.

---

## Metadata dangling references

**Decision (settled):** `setup-bonai-skills` is dropped entirely; the repo uses upstream's `setup-matt-pocock-skills`. The Notion recipe lives in `docs/agents/issue-tracker.md` (see Decision 1).

**Fixed this pass** (operationally-live files):

| File | Fix applied |
|---|---|
| `.claude-plugin/plugin.json` | `setup-bonai-skills` entry → `setup-matt-pocock-skills`. Engineering/productivity/misc set now matches upstream exactly (`implement` + `resolving-merge-conflicts` were already present). |
| `CLAUDE.md` (project) | `## Agent skills` block: `workflow-config.md` reframed as hand-maintained + setup is `/setup-matt-pocock-skills`; Workflow-backend recipe pointer `tracker-primitives/notion.md` → `docs/agents/issue-tracker.md`. |

**Resolved in the brand/architecture pass:**

| File | Resolution |
|---|---|
| `README.md` | Rewritten: intro/install/skills track upstream; setup → `/setup-matt-pocock-skills`; the `tracker-primitives` abstract-verb section replaced by a **Tracker configuration** section pointing at `docs/agents/issue-tracker.md`; `triage`/`handoff` descriptions corrected to upstream behavior; calver `2026.6.6`. |
| `CONTEXT.md` | Setup ref → `/setup-matt-pocock-skills`; Workflow-backend glossary entry now points the recipe at `docs/agents/issue-tracker.md`; moot `tracker-primitives`-naming ambiguity trimmed. |
| `docs/adr/0001–0003` | **Deleted** (per decision — no superseding ADR written). |
| `tiles/` symlinks + manifest | Dangling `setup-bonai-skills` + `tracker-primitives` symlinks removed; `setup-matt-pocock-skills` symlink added; engineering tile `plugin.json` updated. |
| `.claude-plugin/plugin.json` `"name"` | Kept `bonai-skills` — consistent with keeping the `bonai-dev` publishing identity. |

---

## Open decisions

1. **tracker-primitives — RESOLVED via config seam.** The cluster is dropped from `skills/` (skills now match upstream) and its Notion wiring is relocated to `docs/agents/issue-tracker.md` — the per-repo recipe upstream's skills already consume. This keeps the Notion reliability with zero skill-body conflicts going forward. The project `CLAUDE.md` `## Agent skills` block now points the Notion backend at `docs/agents/issue-tracker.md`. Remaining sub-decisions: (a) optionally create `triage-labels.md` + `domain.md` to complete upstream's full setup contract (the restored skills read the block and degrade without them, so this is polish, not load-bearing); (b) decide the two exceptions in §2a — Notion-backed `handoff` and `commands.md` generation.
2. **Versioning — RESOLVED.** Keep calver + tessl tiles. Upstream's `.changeset/` + `package.json` + `CHANGELOG.md` are intentionally not adopted; skip them on future syncs.
3. **Brand/metadata — RESOLVED.** Keep the `bonai-dev` tiles + "Bonai Skills" identity; README/CONTEXT.md rewritten to the converged architecture; ADRs dropped; tile symlinks repaired.
4. **Eval suite — RESOLVED.** Reconciled to the converged skills (see the cumulative log above). One caveat to confirm on the first real `eval run`: `prod-9` (handoff) now asserts the document is written to the **OS temp dir** (upstream behavior) — verify the eval harness can observe out-of-workspace writes (it grades from the agent's transcript/output, so the path the agent reports should suffice; flagged because no other scenario asserts a non-workspace path). (`scenario-11`'s ADR reference was a false alarm — it cites its own `inputs/docs/adr/` fixtures, not a deleted repo ADR.)
5. **§2a exceptions.** `handoff` — **RESOLVED:** take upstream (writes to OS temp dir); alternative handoff location can be flagged per-repo at setup time. `commands.md` auto-generation — still unaddressed (the generation logic lived in the dropped `setup-bonai-skills`; `commands.md` itself is hand-maintained and intact).
