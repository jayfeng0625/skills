---
name: setup-pstack
description: Configure which model and effort pstack uses per role and install pstack's subagents. Detects your available models and writes a model file that overrides the skill defaults. Use for /setup-pstack, "configure pstack models", "pstack effort", or changing pstack's model choices.
metadata:
  tags: [setup, models, configuration]
---

# Setup pstack

Write `~/.claude/pstack-models.md`, the file that sets pstack's model and effort per role, and install pstack's subagents into `~/.claude/agents/`.

The Agent tool takes a `model` per call but no effort. Effort comes from the subagent type's `effort` frontmatter, so step 6 installs one copy of each pstack subagent per effort level, named `<type>-<effort>`. A skill spawns the copy that matches the role's effort and passes the role's model as `model`. A Workflow script passes the same type as `agentType` and the model as `model`.

## Steps

### 1. Detect available models

Enumerate the values the `Agent` tool's `model` parameter accepts in this session. That is the dependable source. If you cannot detect any, ask the user to paste the model IDs they have access to. Never write a real model you have not confirmed is available. The alias `inherit` is always valid even though it is not a detected model. The efforts are `low`, `medium`, `high`, `xhigh`, and `max`; which ones a model honors depends on the model.

### 2. Load current state

The default role-to-model mapping is the file shape shown in step 5 below. If `~/.claude/pstack-models.md` already exists, read it and treat its role values as the current choices. Otherwise start from those defaults. A line whose role is not in step 5, such as `how critics`, is from a retired role. Drop it.

### 3. Map and confirm

**(a) Build the working table** from the skill defaults, and on a re-run keep any role the user changed.

**(b) Show the roles and confirm.** Show every role with its model and effort, marking any real model not in the detected set as needing a choice. Also list each line step 2 dropped. Ask whether to accept as-is or change specific roles, offering the detected models plus `inherit` (this role runs on the parent session's model) as the options, and the five efforts. Prefer AskUserQuestion over free text. For the `interrogate reviewers` panel the value is a list, and one subagent runs per entry, alias entries included, so the list length sets the count. `arena runners` and `architect runners` name the model or models for runners; the orchestrator sets the runner count from the design directions it names, cycling through the listed models. `arena cross-judge pool` is also a list, but Arena selects one value from it that differs from the parent's model when possible. `swarm workers` is the default model for every worker unless a race or comparison assigns another model per arm.

### 4. Validate

Every real model written must be in the detected set. `inherit` always passes. Every effort must be one of the five. If a chosen real model is not available, stop and ask again.

### 5. Write the model file

Write `~/.claude/pstack-models.md` with one line per role, using the same labels poteto-mode uses. A value is a model and an effort separated by a space; a panel list separates its entries with commas. Overwrite the whole file so re-runs stay idempotent. Shape:

```
# pstack model configuration. One line per role. Delete a line to fall back to the skill default.
# A value is "<model> <effort>". Model: opus, fable, sonnet, or haiku (the Agent tool's `model` values).
# Effort: low, medium, high, xhigh, or max. A value with no effort keeps the role's default effort.
# `inherit` as the model: the role runs on the parent session's model (omit `model`). An `inherit` entry in a panel list still counts toward its fan-out.
feature, refactoring: opus medium
bug-fix: opus medium
perf-issue: opus medium
hillclimb: opus medium
judgment and prose: opus high
hardest tasks: fable medium
how explorer: opus medium
how explainer: opus high
why investigators: opus high
why synthesizer: opus high
reflect tooling: opus high
reflect judgment, divergent, synthesizer: opus high
arena runners: opus high
arena cross-judge pool: opus high
swarm workers: opus medium
architect runners: fable high
interrogate reviewers: opus high, fable medium
```

### 6. Install the subagents

Write each subagent definition into `~/.claude/agents/` with the Write tool, overwriting any existing copy:

- `${CLAUDE_SKILL_DIR}/../no-comments/subagents/comment-sicko.md` to `~/.claude/agents/comment-sicko.md`, unchanged.
- `${CLAUDE_SKILL_DIR}/../poteto-mode/subagents/poteto-agent.md` to `~/.claude/agents/poteto-agent.md`, unchanged. `/poteto-mode` routes to it at the session's effort.
- The same `poteto-agent.md` once per effort, to `~/.claude/agents/poteto-agent-<effort>.md`. In each copy, set `name: poteto-agent-<effort>` and add `effort: <effort>` to the frontmatter.
- `${CLAUDE_SKILL_DIR}/subagents/pstack.md` once per effort, to `~/.claude/agents/pstack-<effort>.md`, with the same two frontmatter edits (`name: pstack-<effort>`, `effort: <effort>`).

Skip a source that is not installed and say which. If `~/.claude/agents/` did not exist before this step, tell the user to restart Claude Code so it loads the new agents.

### 7. Confirm

Tell the user the model file was written and the subagents installed, listing the agent files. The model file applies to the next pstack skill run. Re-running this skill updates both, and it is the way to refresh the subagents after `npx skills update`.

### 8. Offer a verification skill (optional)

Check whether the project has a way to drive the real app for proof (a `verify-*` skill, or an existing harness). If not, offer once: "want a project-local verification skill, so agents can drive the app the way a user does and prove changes work? I can generate one with /create-verification-skill." On yes, invoke `/create-verification-skill` (resolves wherever pstack is installed: project or user). On no, move on without pushing.
