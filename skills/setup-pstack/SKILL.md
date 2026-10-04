---
name: setup-pstack
description: Configure which models pstack uses per role and install pstack's subagents. Detects your available models and writes a model file that overrides the skill defaults. Use for /setup-pstack, "configure pstack models", or changing pstack's model choices.
metadata:
  tags: [setup, models, configuration]
---

# Setup pstack

Write `~/.claude/pstack-models.md`, the file that sets pstack's model per role, and install pstack's subagents into `~/.claude/agents/`.

## Steps

### 1. Detect available models

Enumerate the values the `Agent` tool's `model` parameter accepts in this session. That is the dependable source. If you cannot detect any, ask the user to paste the models they have access to. Never write a real model you have not confirmed is available. The alias `inherit` is always valid even though it is not a detected model.

### 2. Load current state

The default role-to-model mapping is the file shape shown in step 5 below. If `~/.claude/pstack-models.md` already exists, read it and treat its role values as the current choices. Otherwise start from those defaults. A line whose role is not in step 5, such as `how critics`, is from a retired role. Drop it.

### 3. Map and confirm

**(a) Build the working table** from the skill defaults, and on a re-run keep any role the user changed.

**(b) Show the roles and confirm.** Show every role with its model, marking any real model not in the detected set as needing a choice. Also list each line step 2 dropped. Ask whether to accept as-is or change specific roles, offering the detected models plus `inherit` (this role runs on the parent session's model) as the options. Prefer AskUserQuestion over free text. For the `interrogate reviewers` panel the value is a list, and one subagent runs per entry, alias entries included, so the list length sets the count. `arena runners` and `architect runners` name the model or models for runners; the orchestrator sets the runner count from the design directions it names, cycling through the listed models. `arena cross-judge pool` is also a list, but Arena selects one value from it that differs from the parent's model when possible. `swarm workers` is the default model for every worker unless a race or comparison assigns another model per arm.

### 4. Validate

Every real model written must be in the detected set. `inherit` always passes. If a chosen real model is not available, stop and ask again.

### 5. Write the model file

Write `~/.claude/pstack-models.md` with one line per role, using the same labels poteto-mode uses. A panel list separates its entries with commas. Overwrite the whole file so re-runs stay idempotent. Shape:

```
# pstack model configuration. One line per role. Delete a line to fall back to the skill default.
# Model: opus, fable, sonnet, or haiku (the Agent tool's `model` values). Subagents run at the session's effort.
# `inherit` as a value: the role runs on the parent session's model (omit `model`). An `inherit` entry in a panel list still counts toward its fan-out.
feature, refactoring: opus
bug-fix: opus
perf-issue: opus
hillclimb: opus
judgment and prose: opus
hardest tasks: fable
how explorer: opus
how explainer: opus
why investigators: opus
why synthesizer: opus
reflect tooling: opus
reflect judgment, divergent, synthesizer: opus
arena runners: opus
arena cross-judge pool: opus
swarm workers: opus
architect runners: fable
interrogate reviewers: opus, fable
```

### 6. Install the subagents

Write each subagent definition into `~/.claude/agents/` with the Write tool, overwriting any existing copy:

- `${CLAUDE_SKILL_DIR}/../no-comments/subagents/comment-sicko.md` to `~/.claude/agents/comment-sicko.md`.
- `${CLAUDE_SKILL_DIR}/../poteto-mode/subagents/poteto-agent.md` to `~/.claude/agents/poteto-agent.md`.

Skip a source that is not installed and say which. If `~/.claude/agents/` did not exist before this step, tell the user to restart Claude Code so it loads the new agents.

### 7. Confirm

Tell the user the model file was written and the subagents installed, listing the agent files. The model file applies to the next pstack skill run. Re-running this skill updates both, and it is the way to refresh the subagents after `npx skills update`.

### 8. Offer a verification skill (optional)

Check whether the project has a way to drive the real app for proof (a `verify-*` skill, or an existing harness). If not, offer once: "want a project-local verification skill, so agents can drive the app the way a user does and prove changes work? I can generate one with /create-verification-skill." On yes, invoke `/create-verification-skill` (resolves wherever pstack is installed: project or user). On no, move on without pushing.
