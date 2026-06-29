---
name: handoff
description: Compact the current conversation into a handoff document for another agent to pick up.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

Write a handoff document summarising the current conversation so a fresh agent can continue the work.

**Where it goes.** This skill produces the document; persisting it is the backend's job. Hand the finished document to the repo's configured workflow backend (see the `## Agent skills` block) to store as a Handoff — a backend skill (this repo uses `/tracker-notion`, which creates it in the Handoffs store and returns a URL) or, if the backend is a per-repo recipe, the workflow in `docs/agents/issue-tracker.md`. **If no backend is configured** (e.g. a no-codebase grilling session), fall back to saving the document in the temporary directory of the user's OS — never the current workspace. Either way, report the resulting URL or path so the next session can reference it.

Include a "suggested skills" section in the document, which suggests skills that the agent should invoke.

Do not duplicate content already captured in other artifacts (PRDs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

Redact any sensitive information, such as API keys, passwords, or personally identifiable information.

If the user passed arguments, treat them as a description of what the next session will focus on and tailor the doc accordingly.
