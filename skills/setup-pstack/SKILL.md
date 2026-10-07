---
name: setup-pstack
description: Configure which model and effort pstack uses per role and install pstack's subagents. Detects your available models and writes a model file that overrides the skill defaults. Use for /setup-pstack, "configure pstack models", or changing pstack's model or effort choices.
metadata:
  tags: [setup, models, configuration]
---

# Setup pstack

Write `~/.claude/pstack-models.md`, the file that sets pstack's model and effort per role, and install pstack's subagents into `~/.claude/agents/`.

## Steps

### 1. Detect available models

Enumerate the values the `Agent` tool's `model` parameter accepts in this session. That is the dependable source. If you cannot detect any, ask the user to paste the models they have access to. Never write a real model you have not confirmed is available. The alias `inherit` is always valid even though it is not a detected model.

### 2. Load current state

The default role mapping is the file shape shown in step 5 below. If `~/.claude/pstack-models.md` already exists, read it and treat its role values as the current choices. An entry with no effort, from a file written before efforts existed, keeps the session's effort. Otherwise start from those defaults. A line whose role is not in step 5, such as `how critics`, is from a retired role. Drop it.

### 3. Map and confirm

**(a) Build the working table** from the skill defaults, and on a re-run keep any role the user changed.

**(b) Show the roles and confirm.** Show every role with its entries, marking any real model not in the detected set as needing a choice. Also list each line step 2 dropped. Ask whether to accept as-is or change specific roles. Each entry is a model and an optional effort. Offer the detected models plus `inherit` (the entry runs on the parent session's model), and the efforts `low`, `medium`, `high`, `xhigh`, and `max`. An entry with no effort runs at the session's effort. Prefer AskUserQuestion over free text. For the `interrogate reviewers` panel the value is a list, and one subagent runs per entry, alias entries included, so the list length sets the count. A panel's entries each carry their own effort. `arena runners` and `architect runners` name the model or models for runners; the orchestrator sets the runner count from the design directions it names, cycling through the listed models. `arena cross-judge pool` is also a list, but Arena selects one value from it that differs from the parent's model when possible. `swarm workers` is the default model for every worker unless a race or comparison assigns another model per arm.

### 4. Validate

Every real model written must be in the detected set. `inherit` always passes. Every effort written must be one of the values the `Agent` tool's `effort` parameter accepts. If a chosen model or effort is not available, stop and ask again.

### 5. Write the model file

Write `~/.claude/pstack-models.md` with one line per role, using the same labels poteto-mode uses. An entry is the model, then a space and the effort when it has one. A panel list separates its entries with commas. Overwrite the whole file so re-runs stay idempotent. Shape:

```
# pstack model configuration. One line per role. Delete a line to fall back to the skill default.
# Entry: `<model> [effort]`. Model: opus, fable, sonnet, or haiku (the Agent tool's `model` values). Effort: low, medium, high, xhigh, or max (its `effort` values). An entry with no effort runs at the session's effort.
# `inherit` as a model: the entry runs on the parent session's model (omit `model`). An `inherit` entry in a panel list still counts toward its fan-out.
feature, refactoring: opus high
bug-fix: opus medium
perf-issue: opus high
hillclimb: opus high
judgment and prose: opus medium
hardest tasks: opus xhigh
how explorer: opus medium
how explainer: opus high
why investigators: sonnet medium
why synthesizer: opus high
reflect tooling: sonnet medium
reflect judgment, divergent, synthesizer: opus high
arena runners: opus medium, fable low
arena cross-judge pool: opus high, fable medium
swarm workers: opus low
architect runners: opus high, fable medium
interrogate reviewers: opus high, fable medium
```

### 6. Install the subagents

Write each subagent definition into `~/.claude/agents/` with the Write tool, overwriting any existing copy:

- `${CLAUDE_SKILL_DIR}/../no-comments/subagents/comment-sicko.md` to `~/.claude/agents/comment-sicko.md`.
- `${CLAUDE_SKILL_DIR}/../poteto-mode/subagents/poteto-agent.md` to `~/.claude/agents/poteto-agent.md`.

Each definition's `model` and `effort` frontmatter applies only to a spawn that passes neither; a spawn's own values take precedence. Skip a source that is not installed and say which. If `~/.claude/agents/` did not exist before this step, tell the user to restart Claude Code so it loads the new agents.

### 7. Confirm

Tell the user the model file was written and the subagents installed, listing the agent files. The model file applies to the next pstack skill run. Re-running this skill updates both, and it is the way to refresh the subagents after `npx skills update`.

### 8. Offer a verification skill (optional)

Check whether the project has a way to drive the real app for proof (a `verify-*` skill, or an existing harness). If not, offer once: "want a project-local verification skill, so agents can drive the app the way a user does and prove changes work? I can generate one with /create-verification-skill." On yes, invoke `/create-verification-skill` (resolves wherever pstack is installed: project or user). On no, move on without pushing.
