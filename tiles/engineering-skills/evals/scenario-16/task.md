I just joined this team and I'm trying to get oriented. Run the zoom-out skill on the `PaymentService` module.

Follow the skill's process exactly:
1. Read `src/payments/PaymentService.ts` first to fix the target.
2. List only publicly exported names (functions, types, interfaces) — skip private internals.
3. Search the codebase (grep or equivalent) for files that import `PaymentService` and list each caller with the file path.
4. Summarize each caller and each downstream dependency in exactly one line — what it owns, not how it works.
5. State which architectural layer PaymentService belongs to and what role it plays there.
6. Name the single best next file to read to go one level deeper, with a one-line reason.

Read `CONTEXT.md` first to ground your naming in the domain glossary.

Output in the compact map format from the skill:
```
<target> — <one-line responsibility>
  exports:  <key public symbols>
  called by:
    <module A> — <why it calls in>
  depends on:
    <module B> — <what it needs downstream>
  fits: <architectural layer and role>
```
