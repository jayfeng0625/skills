# Bonai Skills

A personal, Notion-first set of agent skills I use every day. Packaged as two private tessl tiles under the `bonai-dev` workspace; both ship at the same YYYY.M.patch calver.

| Tile | Skills | Latest |
|---|---|---|
| [`bonai-dev/engineering-skills`](./skills/engineering/) | Daily code-work skills (setup, TDD, diagnosis, grilling, prototyping, triage, PRD/issue conversion, architecture review, zoom-out, thermo-nuclear quality review) | `2026.6.1` |
| [`bonai-dev/productivity-skills`](./skills/productivity/) | General workflow skills (caveman compression, non-code grilling, teaching, cross-session handoffs, skill authoring) | `2026.6.1` |

Skills lean on the agent to interrogate the user (via `AskUserQuestion`-style flows) rather than prescribing rigid checklists. The set replaces my prior use of the `superpowers` plugin — bonai is standalone and has no superpowers fallback.

## Layout

```
skills/
  engineering/        ← daily code work (tile: bonai-dev/engineering-skills)
    tracker-primitives/ ← shared MCP/CLI recipes for the abstract-verb contract
  productivity/       ← daily non-code workflow (tile: bonai-dev/productivity-skills)
  misc/               ← kept around but rarely used
  personal/           ← tied to my own setup, not promoted
  in-progress/        ← drafts not yet ready to ship
  deprecated/         ← no longer used
```

## How to install (consumer side)

In a target repo:

```sh
tessl install bonai-dev/engineering-skills@2026.6.1
tessl install bonai-dev/productivity-skills@2026.6.1
```

Then run the setup skill once per repo:

```
/setup-bonai-skills
```

This writes `commands.md` and `workflow-config.md` into a config dir chosen at setup (default `docs/agents/`): `commands.md` holds the canonical test/lint/typecheck/build commands, and `workflow-config.md` holds the three workflow database IDs (Issues, PRDs, Handoffs) and property mappings, including the Handoffs DB's `Epic` select column. The domain glossary and ADRs live on the filesystem (`CONTEXT.md` + `docs/adr/`). Engineering skills read these to stay language-agnostic and tracker-agnostic. The productivity tile is zero-config — no per-repo setup required.

## The abstract-verb contract

Skill bodies use only **abstract verbs** — never concrete tool calls. `skills/engineering/tracker-primitives/` translates each verb to the chosen backend (Notion, GitHub, or local markdown). Per-repo IDs live in `workflow-config.md`, resolved via the `Config dir:` named in the `## Agent skills` block. See [`tracker-primitives/README.md`](./skills/engineering/tracker-primitives/README.md) for the controlled vocabulary (6 workflow verbs; the glossary/ADR verbs are now filesystem conventions — `CONTEXT.md` + `docs/adr/`).

## Skills

### Engineering (11)

- [`setup-bonai-skills`](./skills/engineering/setup-bonai-skills/SKILL.md) — per-repo config scaffolding
- [`tdd`](./skills/engineering/tdd/SKILL.md) — test-driven development loop
- [`diagnose`](./skills/engineering/diagnose/SKILL.md) — disciplined bug-diagnosis loop
- [`grill-with-docs`](./skills/engineering/grill-with-docs/SKILL.md) — grilling that writes glossary / ADRs inline
- [`prototype`](./skills/engineering/prototype/SKILL.md) — throwaway prototype for logic or UI questions
- [`triage`](./skills/engineering/triage/SKILL.md) — issue triage state machine; posts agent briefs as child pages
- [`to-issues`](./skills/engineering/to-issues/SKILL.md) — break a plan into independently-grabbable issues
- [`to-prd`](./skills/engineering/to-prd/SKILL.md) — synthesize current context into a PRD
- [`improve-codebase-architecture`](./skills/engineering/improve-codebase-architecture/SKILL.md) — find deepening opportunities, HTML-report-driven
- [`zoom-out`](./skills/engineering/zoom-out/SKILL.md) — higher-level perspective on unfamiliar code
- [`thermo-nuclear-code-quality-review`](./skills/engineering/thermo-nuclear-code-quality-review/SKILL.md) — extremely strict maintainability review hunting code-judo simplifications

### Productivity (5)

- [`caveman`](./skills/productivity/caveman/SKILL.md) — ultra-compressed communication mode
- [`grill-me`](./skills/productivity/grill-me/SKILL.md) — non-code interrogation about a plan / design / talk
- [`teach`](./skills/productivity/teach/SKILL.md) — teach a skill or concept over multiple sessions in a stateful workspace
- [`handoff`](./skills/productivity/handoff/SKILL.md) — cross-session handoff documents, written to the Handoffs DB with an Epic tag (uses engineering's `tracker-primitives`)
- [`write-a-skill`](./skills/productivity/write-a-skill/SKILL.md) — produce a new skill folder (tile-agnostic)

## License

MIT — see [LICENSE](./LICENSE).
