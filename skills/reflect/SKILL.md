---
name: reflect
description: Spawn three parallel review subagents over the active transcript, surface learnings, and route each to a concrete edit on an existing skill. Use when the user says reflect.
disable-model-invocation: true
metadata:
  tags: [retrospective, transcripts, subagents]
---

# Reflect

Mine the current conversation for durable learnings, then route them into skill edits.

## When to invoke

Invoke when the user says "reflect" or "/reflect". Skip when the conversation is trivial, off-topic, or already covered by an existing skill the parent followed correctly. One-offs are not learnings.

## Process

### 1. Locate the active transcript

The parent finds its own transcript file before fanning out. Claude Code stores it at `~/.claude/projects/<project>/${CLAUDE_SESSION_ID}.jsonl`, where `<project>` is the launch directory with every non-alphanumeric character replaced by `-`. Build that absolute path and read its first line with the Read tool to confirm it exists. Do not open other files under `~/.claude/projects/`. That crosses project boundaries and reads private chats from unrelated projects.

Two transcript layouts: the session (`<session-id>.jsonl`) and its subagents (`<session-id>/subagents/agent-<id>.jsonl`). Each line is one JSON record; `user` and `assistant` records carry `message.content`.

Take the session path. If no path resolves, write a tight digest of the session and pass that instead.

### 2. Spawn three reviewers in parallel

One message, three `Agent` calls, each with the subagent type and `model` its role line sets below. Reviewers need MCP access for context lookups (tickets, chat threads, observability traces referenced in the transcript), and the `pstack-<effort>` type carries the session's MCP tools.

Each reviewer and the synthesizer name a role line in `~/.claude/pstack-models.md` and a default. A value is a model and an effort, such as `opus high`. Take the line's value, or the default if the file or the line is missing; a value with no effort keeps the default's effort. Spawn subagent type `pstack-<effort>` with `model` set to the model, left unset when the model is `inherit`. In a Workflow script, pass that type as `agentType` and the model as `model`. If the Agent tool offers no `pstack-<effort>` type, spawn `general-purpose` and tell the user to run `/setup-pstack`. If the Agent tool rejects a model, use `inherit` and say so.

| Lens | Role line | Default | Prompt template |
|---|---|---|---|
| Judgment | `reflect judgment, divergent, synthesizer` | `opus high` | `references/judgment-reviewer.md` |
| Tooling | `reflect tooling` | `opus high` | `references/tooling-reviewer.md` |
| Divergent | `reflect judgment, divergent, synthesizer` | `opus high` | `references/divergent-reviewer.md` |

Pass each template verbatim, substituting the transcript path or digest where marked. Reviewers return findings in the `Agent` response body.

### 3. Synthesize

One `Agent` call, with the subagent type and `model` from the `reflect judgment, divergent, synthesizer` line (default `opus high`). The synthesizer's quality check includes spot-verifying citations, which can require MCP access. Use `references/synthesizer.md` verbatim, with each reviewer's full output inlined where marked. The synthesizer returns a structured Accepted / Rejected / Backlog list.

### 4. Structural enforcement check

Sanity-check the synthesizer's Accepted list. For any item that would be enforced more reliably by a lint rule, script, metadata flag, or runtime check, move it from Accepted to Backlog. See the **encode-lessons-in-structure** principle skill.

### 5. Apply

Before applying any Accepted edit, present the synthesizer's full Accepted/Rejected/Backlog output to the user and wait for explicit approval. The user picks which subset to apply and may redirect routings. Skill changes affect every future agent in the org. Do not auto-apply.

Backlog items file to whatever devex / backlog tracker your team uses automatically. Only the Accepted list waits for approval.

For each approved Accepted item, follow the Routing field exactly:

- Trivial existing-skill edit (a one-line bullet, a tightened sentence, a stale fact corrected): parent does directly.
- Substantive existing-skill edit (a new section, a new pattern table, more than ~10 lines): hand to Anthropic's `skill-creator` skill (from the skill-creator plugin) and run its draft / test / iterate loop.
- `tune description: <skill path>` (the skill exists but didn't trigger when it should have): hand to `skill-creator` and run its description-optimization loop.
- `new skill via skill-creator: <kebab-name>`: hand creation to `skill-creator`. Do not invent the shape ad hoc.

If your environment ships a SKILL.md validator, run it on every touched skill before declaring done. Skip this step if it doesn't.

### 6. Summarize for the user

Short list, no preamble:

- Edits applied: `<skill path>`. What changed, one line each.
- New skills created: `<skill path>`. One line each (rare).
- Backlog filed to the devex tracker: `<issue title>` (`<tags>`). One line each.
- Dropped: one line per rejected finding + reason from the synthesizer.
