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
