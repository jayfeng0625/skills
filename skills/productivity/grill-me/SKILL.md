---
name: grill-me
description: Interrogates the user about a plan, design, talk, or strategy — probing assumptions, surfacing edge cases, challenging trade-offs, and walking each branch of the decision tree until the thinking is fully resolved. Recommended answers are offered for every question. For non-code artifacts only — use `/grill-with-docs` instead when grilling against an existing codebase. Use when the user says "grill me", "stress-test this plan", "interrogate my design", "challenge this idea", "poke holes in this", or wants someone to push back hard on a draft / outline / proposal before committing to it.
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

## Example question shape

> **Audience.** This talk seems pitched at staff+ engineers, but the abstract mentions "anyone curious about distributed systems." Pick one — I'd lean staff+ because the second half assumes Raft. Going broader means cutting or motivating Raft. Which?

— one question, one recommendation, one branch opens up.
