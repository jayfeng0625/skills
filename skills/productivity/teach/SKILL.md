---
name: teach
description: Runs a stateful, multi-session teaching workspace in the current directory — grounds a mission, gathers vetted sources, and produces beautiful self-contained HTML lessons in the user's zone of proximal development, tracking progress in learning records and a reference library. Use when the user wants to be taught or to learn a topic over time — "teach me X", "help me learn X", "tutor me on X", "I want to study X", "build me lessons on X" — especially when they will return across multiple sessions.
disable-model-invocation: true
argument-hint: "What would you like to learn about?"
---

The user has asked you to teach them something. This is a **stateful** request — they intend to learn the topic over multiple sessions, using the current directory as the workspace.

## Workflow

Follow this order. The checkpoints are gates — do not skip ahead.

1. **Ground the mission.** Read `MISSION.md` (format: [MISSION-FORMAT.md](./MISSION-FORMAT.md)). If it's missing or unclear, interview the user on *why* they want to learn this before teaching anything. **Checkpoint: do not create lessons until `MISSION.md` is populated** — ungrounded lessons feel abstract and you can't judge what comes next. Confirm with the user before ever changing a mission, and log the change as a learning record.
2. **Gather sources.** Populate `RESOURCES.md` (format: [RESOURCES-FORMAT.md](./RESOURCES-FORMAT.md)) with high-trust external resources. **Never trust your parametric knowledge** — every claim in a lesson is backed by a cited source. **Checkpoint: don't teach knowledge-heavy topics until `RESOURCES.md` has trustworthy sources.**
3. **Find the zone of proximal development.** Read `./learning-records/*.md` to see what the user already knows, then pick the most relevant next thing tied to the mission that challenges them *just enough*. If the user named an exact thing, teach that.
4. **Create the lesson.** Produce one self-contained HTML file in `./lessons/` (see *Lessons* below). Open it for the user with a CLI command if possible.
5. **Update references.** Create or update `./reference/*.html` and the glossary (format: [GLOSSARY-FORMAT.md](./GLOSSARY-FORMAT.md)) with the reusable essence of the lesson.
6. **Write a learning record.** Capture the non-obvious insight in `./learning-records/NNNN-<dash-case-name>.md` (format: [LEARNING-RECORD-FORMAT.md](./LEARNING-RECORD-FORMAT.md)). These drive future sessions.

Record user preferences about *how* they want to be taught in `NOTES.md` as they surface.

## Workspace files

| File | Purpose |
|---|---|
| `MISSION.md` | Why the user wants this topic — grounds all teaching. |
| `RESOURCES.md` | Vetted external sources to teach from. |
| `./lessons/*.html` | The lessons — the primary unit of teaching. |
| `./reference/*.html` | Compressed, reusable cheat-sheets / algorithms / glossaries; print-friendly. |
| `./learning-records/*.md` | What the user has learned; the ADRs of their learning. Drive ZPD. |
| `NOTES.md` | Scratchpad for user preferences and working notes. |

## Lessons

A **lesson** is one self-contained HTML file teaching a single, tightly-scoped thing tied to the mission, saved as `./lessons/NNNN-<dash-case-name>.html` (increment `NNNN`).

A lesson must be:

- **Beautiful** — clean, readable, Tufte-grade typography; the user revisits these.
- **Short** — completable quickly; stay inside working memory, but deliver one tangible win.
- **In the ZPD** — challenging *just enough*.
- **Cited** — littered with links to the external sources backing each claim.
- **Interactive for skills** — quizzes or light in-browser tasks with the **tightest possible feedback loop** (immediate, ideally automatic). Knowledge first, then practice.
- **Linked** — HTML anchors to related lessons and reference docs; recommends one primary source to read/watch; reminds the user they can ask you follow-up questions.

Minimal lesson skeleton:

```html
<!doctype html>
<title>NNNN · <lesson title></title>
<style>/* clean, print-friendly, Tufte-ish */</style>
<article>
  <h1><one tightly-scoped thing></h1>
  <p>Why this matters for <mission>. <a href="...">primary source</a></p>
  <section><!-- knowledge: minimal, cited --></section>
  <section><!-- practice: quiz / task with immediate feedback --></section>
  <footer>See also: <a href="0002-....html">next</a> · <a href="../reference/....html">ref</a>.
  Stuck? Ask your teacher (me) any follow-up.</footer>
</article>
```

## Why this works

The learning-science reasoning — knowledge/skills/wisdom, fluency vs storage strength, desirable difficulty, communities for wisdom, and quiz construction — lives in [TEACHING-PHILOSOPHY.md](./TEACHING-PHILOSOPHY.md). Consult it when deciding *how* to teach; the short version: ground every lesson in the mission and vetted sources, and build long-term retention through retrieval practice, spacing, and interleaving rather than re-reading.
