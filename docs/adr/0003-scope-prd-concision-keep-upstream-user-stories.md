# Scope PRD concision; keep upstream's extensive User Stories

Builds on [0002](./0002-unbake-tracker-config-from-skill-bodies.md).

## Context

The fork's `/to-prd` output was consistently too verbose — 10+ near-duplicate user stories, paragraph-per-decision rationale that restated context, a catch-all *Further Notes* that duplicated *Out of Scope*. We rewrote `to-prd`/`to-issues` for terseness.

On review against `mattpocock/skills` (upstream), one part of that rewrite **reversed an explicit upstream design choice**: upstream's `to-prd` mandates a User Stories list that is _"extremely extensive and cover[s] all aspects of the feature."_ Upstream is not iterating on these skills (its recent work is the teaching skills; `to-prd`/`to-issues` were last touched 2026-05/06). So the verbosity there is deliberate, not a defect — and our "minimal distinct set, merge near-duplicates" rewrite was a philosophical reversal, not a bugfix.

Eval scenarios (`scenario-12` to-prd, `scenario-13` to-issues; dual-objective terseness-vs-fidelity criteria) showed the terse rewrite **helped fidelity** (load-bearing spec inlined verbatim) but introduced an over-compression bug — a spec **table** collapsed to 38% reproduction — and, on `glm-5.1`, the merge-stories instruction behaved erratically (a sign we were tuning against upstream's grain).

## Decision

Keep upstream's intent where upstream is explicit; apply concision only where it is not. Concretely:

1. **User Stories revert to upstream intent** — "a LONG, extensive list covering all aspects". No merge/minimal-set instruction. Breadth is the point there.
2. **Implementation Decisions stay terse** — one line per decision, claim + at most one *why* clause. Upstream mandates no verbosity here, so this is concision in open territory, not a reversal.
3. **Further Notes constrained** — links/follow-ups only, omit otherwise. Same rationale.
4. **Spec-fidelity guardrail added** (`to-prd` house style): tables/regex/schema/ordering reproduced **verbatim**, rendered as tables with every row/column, "fidelity wins" when it conflicts with terseness. Purely additive — upstream has no opposing rule — and it fixed the table regression (38% → 100% once hardened). The prototype-snippet provenance exception is preserved.
5. **`to-issues` terseness + delta-not-duplication kept** — this *aligns* with upstream, whose `to-issues` already asks for "a concise description"; the delta-not-duplication rule (reference the linked PRD for shared spec, inline only each slice's load-bearing detail) is additive.
6. **No per-model micro-tuning.** The `glm-5.1` story-merge / PRD-coverage wobbles were n=1 and chased a target we've now reverted; we do not tune skill wording against a single eval run.

## Consequences

- Divergence from upstream is now **scoped to prose/decision concision + a fidelity guardrail**. User Stories stay upstream-aligned, so future re-sync from upstream on that section is conflict-free.
- The fidelity guardrail is a genuine improvement upstream lacks; it is a candidate to **contribute back** rather than hold as fork-only.
- `scenario-12`'s user-stories check now rewards **extensive coverage of all aspects** (upstream intent), not merging — the eval measures the skill we actually ship.
- Eval signal is treated as **directional at n=1**; confirm with `--runs ≥3` before acting on any single check, and only on `glm-5.1` (the agent the CI Impact runs use) — see [[tessl-eval-default-agent]] in agent memory.
