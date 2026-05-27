---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

This skill is for **non-code grilling** — designs, strategies, plans, talks, and other artifacts where there is no codebase to read against. The point of the grilling is the user's own thinking, not domain alignment against a repository.

If the artifact you want to grill has a codebase or existing domain documentation (glossary, ADRs), use `/grill-with-docs` (from `bonai-dev/engineering-skills`) instead — that skill grounds the conversation in the project's existing terminology and architectural decisions before challenging the new idea.

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.
