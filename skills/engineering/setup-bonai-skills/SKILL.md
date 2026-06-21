---
name: setup-bonai-skills
description: Sets up an `## Agent skills` block in AGENTS.md/CLAUDE.md and `docs/agents/` so the engineering skills know this repo's per-language commands and Notion database IDs. Run before first use of `tdd`, `diagnose`, `grill-with-docs`, `prototype`, or any other engineering skill that reads from `docs/agents/`.
disable-model-invocation: true
---

# Setup Bonai Skills

Scaffold the per-repo configuration that the engineering skills assume:

- **Commands** — the canonical shell commands for running tests, linting, type-checking, and building this repo. Skills never name a test runner directly; they read these.
- **Notion** — workspace ID, the 5 database IDs (Issues, PRDs, Handoffs, Domain Glossary, ADRs), and the property → canonical-role mappings so skills can use abstract verbs.

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `AGENTS.md` and `CLAUDE.md` at the repo root — does either exist? Is there already an `## Agent skills` section?
- `docs/agents/` — does this skill's prior output already exist? If `commands.md` or `notion.md` is present, treat it as the user's authoritative version and offer to edit it rather than overwriting.
- Project manifest files for inference hints only: `package.json`, `pyproject.toml`, `Cargo.toml`, `build.gradle(.kts)`, `Makefile`. Surface candidate commands from `scripts` blocks, but the user's answer is authoritative — never silently detect.

### 2. Walk the user through Commands

Use `AskUserQuestion` to ask about each of the four canonical commands in sequence. For each, present any inferred candidates as the first option labelled "(Inferred from <file>)".

For each command, ask one question. Example for `test_command`:

> What command runs the test suite for this repo? Skills like `/tdd` and `/diagnose` will use this verbatim — it should be the single command that runs all tests from a clean shell.

Repeat for `lint_command`, `typecheck_command`, `build_command`. If any of the four doesn't apply (e.g. a TS-only repo with no separate build step), accept "n/a" — skills will skip that command when it's blank.

### 3. Walk the user through Notion

Notion is the default backend in Stage 1; the interactive flow below is Notion-specific. If the user does not use Notion, point them at the reference recipes in [../tracker-primitives/gh.md](../tracker-primitives/gh.md) or [../tracker-primitives/local.md](../tracker-primitives/local.md) and let them hand-author `docs/agents/<backend>.md` from those files — the engineering tile still works, just without the interactive setup for that backend.

For Notion users, ask in sequence:

1. **Workspace ID.** "Paste the workspace ID for the Notion workspace you'll use for this repo."
2. **The 5 database IDs.** One question per DB: Issues DB, PRDs DB, Handoffs DB, Domain Glossary DB, ADRs DB. For each, ask: "Paste the database ID, or say 'create' and I will create it from a seed schema." If the user says 'create', call `mcp__notion__notion-create-database` against the workspace using the matching DB's property schema from the **`## DB seed schemas`** section of [`notion.template.md`](./notion.template.md). If the create call fails (no MCP write permission, auth error), stop and tell the user — they need to grant Notion MCP write access or create the DB manually and re-run, in which case prompt for the ID instead.
3. **Property mappings for the Issues DB.** Ask the user to confirm or override the canonical Status mappings: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. Default: each role's string equals its name. Ask the user to confirm or override the Category mappings: `bug`, `enhancement`. Default: each maps to its own name. Ask whether the DB has a `Blocked by` relation property; if so, capture its exact name.

### 4. Confirm and write

Show the user a draft of:

- The `## Agent skills` block to add to whichever of `CLAUDE.md` / `AGENTS.md` is being edited (see step 5 for selection rules). The block includes a **Domain language** entry pointing read-only consumers (`/tdd`, `/diagnose`) directly at the Glossary + ADRs DBs without going through `tracker-primitives/`.
- The contents of `docs/agents/commands.md` (use [`commands.template.md`](./commands.template.md) as the seed)
- The contents of `docs/agents/notion.md` (use [`notion.template.md`](./notion.template.md) as the seed)

Let them edit before writing.

### 5. Write

**Pick the file to edit:**

- If `CLAUDE.md` exists, edit it.
- Else if `AGENTS.md` exists, edit it.
- If neither exists, ask the user which one to create — don't pick for them.

Never create `AGENTS.md` when `CLAUDE.md` already exists (or vice versa) — always edit the one already there.

If an `## Agent skills` block already exists, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

The block:

```markdown
## Agent skills

### Commands

Repo-wide commands for testing, linting, type-checking, and building. See `docs/agents/commands.md`.

### Notion

Workspace, database IDs, and property mappings used by tracker-primitives. See `docs/agents/notion.md`.

### Domain language

Domain glossary and ADRs live in the Notion workspace — see `docs/agents/notion.md` for the Domain Glossary DB ID and ADRs DB ID. To consult them, use `mcp__notion__notion-fetch` on the respective DB ID. This is the read path for skills that ground in domain language without otherwise needing `tracker-primitives/` (e.g. `/tdd`, `/diagnose`).
```

If the user picked a non-Notion backend (gh / local), substitute the matching pointer instead — for gh: "Domain glossary lives in `CONTEXT.md` at the repo root; ADRs in `docs/adr/`." For local: same convention. Stage 1's interactive flow is Notion-only; non-Notion repos hand-author this entry per the relevant `tracker-primitives/<backend>.md`.

Then write `docs/agents/commands.md` and `docs/agents/notion.md` using the templates in this skill folder.

### 6. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `docs/agents/*.md` directly later — re-running this skill is only necessary to switch backends or restart from scratch.
