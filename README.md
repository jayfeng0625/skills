# Bonai Skills

A personal, Notion-first set of agent skills I use every day. Packaged as two private tessl tiles under the `bonai-dev` workspace.

| Tile | Skills | Calver |
|---|---|---|
| [`bonai-dev/engineering-skills`](./skills/engineering/) | Daily code-work skills (TDD, diagnosis, grilling against docs, prototyping, repo setup) | `2026.5.0` |
| `bonai-dev/productivity-skills` | General workflow skills (not yet published) | — |

Skills lean on the agent to interrogate the user (via `AskUserQuestion`-style flows) rather than prescribing rigid checklists. The set replaces my prior use of the `superpowers` plugin — bonai is standalone and has no superpowers fallback.

## Layout

```
skills/
  engineering/        ← daily code work (tile: bonai-dev/engineering-skills)
    tracker-primitives/ ← shared MCP/CLI recipes for the abstract-verb contract
  productivity/       ← daily non-code workflow (tile: bonai-dev/productivity-skills, Stage 2)
  misc/               ← kept around but rarely used
  personal/           ← tied to my own setup, not promoted
  in-progress/        ← drafts not yet ready to ship
  deprecated/         ← no longer used
```

## How to install (consumer side)

In a target repo, install the engineering tile from tessl:

```sh
tessl install bonai-dev/engineering-skills@2026.5.0
```

Then run the setup skill once per repo:

```
/setup-bonai-skills
```

This writes `docs/agents/commands.md` (canonical test/lint/typecheck/build commands) and `docs/agents/notion.md` (the 5 Notion database IDs and property mappings). Engineering skills read these to stay language-agnostic and tracker-agnostic.

## The abstract-verb contract

Skill bodies use only **abstract verbs** — never concrete tool calls. `skills/engineering/tracker-primitives/` translates each verb to the chosen backend (Notion, GitHub, or local markdown). Per-repo IDs live in `docs/agents/notion.md` (or equivalent). See [`tracker-primitives/README.md`](./skills/engineering/tracker-primitives/README.md) for the controlled vocabulary.

## Skills

### Engineering (11)

Stage 1 — in the `bonai-dev/engineering-skills@2026.5.0` tile manifest:

- [`setup-bonai-skills`](./skills/engineering/setup-bonai-skills/SKILL.md) — per-repo config scaffolding
- [`tdd`](./skills/engineering/tdd/SKILL.md) — test-driven development loop
- [`diagnose`](./skills/engineering/diagnose/SKILL.md) — disciplined bug-diagnosis loop
- [`grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) — grilling that writes glossary/ADRs inline
- [`prototype`](./skills/engineering/prototype/SKILL.md) — throwaway prototype for logic or UI questions

Stage 2 — in the repo, not yet in the tile manifest:

- [`handoff`](./skills/engineering/handoff/SKILL.md) — conversation handoff documents
- [`triage`](./skills/engineering/triage/SKILL.md) — issue triage state machine
- [`improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) — find deepening opportunities
- [`to-issues`](./skills/engineering/to-issues/SKILL.md) — break a plan into issues
- [`to-prd`](./skills/engineering/to-prd/SKILL.md) — synthesize current context into a PRD
- [`zoom-out`](./skills/engineering/zoom-out/SKILL.md) — higher-level perspective on unfamiliar code

### Productivity (3)

Stage 2 — productivity tile not yet scaffolded:

- [`caveman`](./skills/productivity/caveman/SKILL.md) — ultra-compressed communication mode
- [`grill-me`](./skills/productivity/grill-me/SKILL.md) — non-code interrogation about a plan
- [`write-a-skill`](./skills/productivity/write-a-skill/SKILL.md) — produce a new skill folder

## License

MIT — see [LICENSE](./LICENSE).
