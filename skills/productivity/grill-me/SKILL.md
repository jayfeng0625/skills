---
name: grill-me
description: Interrogates the user about a plan, design, talk, or strategy — probing assumptions, surfacing edge cases, challenging trade-offs, and walking each branch of the decision tree until the thinking is fully resolved. Recommended answers are offered for every question. For non-code artifacts only — use `/grill-with-docs` instead when grilling against an existing codebase. Use when the user says "grill me", "stress-test this plan", "interrogate my design", "challenge this idea", "poke holes in this", or wants someone to push back hard on a draft / outline / proposal before committing to it.
disable-model-invocation: true
---

This skill is for **non-code grilling** — designs, strategies, plans, talks, and other artifacts where there is no codebase to read against. The point of the grilling is the user's own thinking, not domain alignment against a repository.

## How to grill

**Interview the user relentlessly** about every aspect of the artifact until you and the user reach a shared understanding of each decision. **Ask one question at a time** — never batch. Walk the decision tree depth-first.

1. **Map the surface.** Identify the dimensions worth probing — typically: assumptions, audience, trade-offs, edge cases, dependencies between decisions, what failure looks like. Pick the dimension where the plan is weakest.
2. **Surface the question + your recommended answer.** State which way you'd lean and why, then stop.
3. **Walk the tree depth-first.** When the user answers, follow the decision that just opened up — don't jump to a sibling branch yet. Resolve one path before backtracking.
4. **Backtrack on signal.** When the current branch is fully resolved (or the user says "skip"), pop up one level and pick the next-weakest dimension. Keep a running mental list of branches not yet visited.
5. **Stop when the tree is resolved or the user calls it.** End with a tight summary: which decisions are now firm, which branches you didn't walk, and one sentence on what would change your mind on the weakest decision.

If the user references a code path in their answer, explore that file rather than asking them to summarize it.

## The Iron Law: a question without your recommended answer is not grilling

**Every single question you pose carries your recommended answer, immediately, no exceptions.** A bare question is a survey; the recommendation is the grill — it's your judgement on the fork that the user is paying for. This holds in *both* modes below. If you can't form a recommendation, the question is too vague — sharpen it until you can. A question list with missing recommendations is an incomplete deliverable, not a stylistic choice.

## Pick the mode

- **The user asks for a document / file / "write it up" / "produce a grilling" → Written mode.** Any request to write the grilling to a file (e.g. `grill-session.md`) is Written mode.
- **Otherwise → Interactive mode.** Ask one question at a time, each with its recommendation, and stop; walk the tree depth-first as the user answers.

## Written mode — required structure

Every numbered entry MUST have all three parts, in this exact shape:

```
### <N>. <Dimension> — <one-line framing of what's at stake>
<The probing question.>
**Recommended:** <the answer you'd back, plus a one-line rationale.>
```

- Emit **8+ distinct numbered questions** on a non-trivial artifact — relentless coverage, not a skim. Each targets a different weakness.
- **The `**Recommended:**` line is mandatory on every entry.** This is the one check most likely to be missed — do not skip it.
- **Order by dependency:** a question whose answer others assume comes first (pricing before the acquisition math that uses the price). Name the dependency when it's load-bearing.
- Cover the weak branches the author hasn't questioned — missing competitive response, team gaps, growth assumptions taken on faith — not just the obvious surface issues.

**Before returning the document, verify:** walk every `### N.` heading and confirm a `**Recommended:**` line sits directly under it. If any question lacks one, add it before you finish. A document where any question has no recommendation is not done.

```
### 1. Pricing — $49/mo, monthly only, no annual discount
Is monthly-only leaving money on the table with enterprise buyers?
**Recommended:** Add an annual tier at ~17% off — it pulls forward cash and cuts churn; revisit the $49 anchor only after 20+ paid accounts.

### 2. Customer acquisition — assumes the $49 price from Q1
Does the CAC math survive if Q1 moves the price?
**Recommended:** Re-run payback at $49 and at the annual-equivalent before committing the channel spend; flag this as blocked on Q1.
```

## Example question shape (interactive)

> **Audience.** This talk seems pitched at staff+ engineers, but the abstract mentions "anyone curious about distributed systems." Pick one — I'd lean staff+ because the second half assumes Raft. Going broader means cutting or motivating Raft. Which?

— one question, one recommendation, one branch opens up.
