---
name: write-a-skill
description: Produces a new skill folder — SKILL.md with valid frontmatter (name, description, optional metadata), an instructional body, and any supporting reference files — following the progressive-disclosure pattern (description discovered first, body loaded on activation, references loaded on demand). Tile-agnostic; the resulting folder can be dropped into engineering/, productivity/, or any tile. Use when the user says "write a skill", "create a new skill", "scaffold a skill", "make a SKILL.md for X", "I need a skill that does Y", or wants to package an agent workflow as a reusable skill.
---

# Writing Skills

## Process

1. **Gather requirements** - ask user about:
   - What task/domain does the skill cover?
   - What specific use cases should it handle?
   - Does it need executable scripts or just instructions?
   - Any reference materials to include?

2. **Draft the skill** - create:
   - SKILL.md with concise instructions
   - Additional reference files if content exceeds 500 lines
   - Utility scripts if deterministic operations needed

3. **Review with user** - present draft and ask:
   - Does this cover your use cases?
   - Anything missing or unclear?
   - Should any section be more/less detailed?

## Skill Structure

```
skill-name/
├── SKILL.md           # Main instructions (required)
├── REFERENCE.md       # Detailed docs (if needed)
├── EXAMPLES.md        # Usage examples (if needed)
└── scripts/           # Utility scripts (if needed)
    └── helper.js
```

## SKILL.md Template

```md
---
name: skill-name
description: Brief description of capability. Use when [specific triggers].
---

# Skill Name

## Quick start

[Minimal working example]

## Workflows

[Step-by-step processes with checklists for complex tasks]

## Advanced features

[Link to separate files: See [REFERENCE.md](REFERENCE.md)]
```

## Description Requirements

- Max 1024 chars, third person.
- First sentence: what it does (concrete actions, not abstract concepts).
- Second sentence: `Use when [specific triggers]` — list real phrasings a user would say.

Good: `Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when user mentions PDFs, forms, or document extraction.`

Bad: `Helps with documents.` — gives the agent no way to distinguish this from other document skills.

## When to Add Scripts

Add utility scripts when:

- Operation is deterministic (validation, formatting)
- Same code would be generated repeatedly
- Errors need explicit handling

Scripts save tokens and improve reliability vs generated code.

## When to Split Files

Split into separate files when:

- SKILL.md exceeds 100 lines
- Content has distinct domains (finance vs sales schemas)
- Advanced features are rarely needed

## Review Checklist

After drafting, verify:

- [ ] Description includes triggers ("Use when...")
- [ ] SKILL.md under 100 lines
- [ ] No time-sensitive info
- [ ] Consistent terminology
- [ ] Concrete examples included
- [ ] References one level deep

## Validate before declaring done

Run these checks on the drafted skill folder before handing back:

```bash
# Frontmatter parses as valid YAML
python3 -c "import yaml,sys; yaml.safe_load(open('skill-name/SKILL.md').read().split('---')[1])" \
  && echo "frontmatter OK"

# Description under 1024 chars
desc_chars=$(awk '/^description:/{sub(/^description:[[:space:]]*/, ""); print length}' skill-name/SKILL.md)
[ "$desc_chars" -le 1024 ] && echo "description length OK ($desc_chars chars)"

# SKILL.md body length sane
lines=$(wc -l < skill-name/SKILL.md)
[ "$lines" -le 100 ] && echo "body length OK ($lines lines)" \
  || echo "WARN: $lines lines — consider splitting into reference files"
```

If any check fails, fix and re-run. Don't call the skill complete until all three pass.

## Concrete example

A complete one-file skill (no supporting refs needed) for renaming a tracked branch:

```md
---
name: rename-branch
description: Renames the current git branch locally and on the upstream remote, then sets the new branch to track upstream. Use when the user says "rename this branch", "change the branch name", or wants to fix a typo in a feature branch name without losing history.
---

# Rename branch

1. Capture the current branch name: `old=$(git branch --show-current)`.
2. Ask the user for the new name.
3. Run:
   ```
   git branch -m "$old" "$new"
   git push origin -u "$new"
   git push origin --delete "$old"
   ```
4. Confirm with the user: report the new tracking branch and that the old upstream is gone.
```
