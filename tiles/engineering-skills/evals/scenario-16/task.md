I just joined this team and need orientation on the `PaymentService` module. Map it for me.

1. Read `CONTEXT.md` first for domain vocabulary.
2. Read `src/payments/PaymentService.ts` to anchor the module — that's your target.
3. List only its publicly exported names (functions, types, interfaces) — skip private internals.
4. Search the codebase for files that import `PaymentService` (use grep or rg on `../payments/PaymentService` or `PaymentService`). List each caller with its file path.
5. Summarize the target and each direct collaborator (callers + downstream deps) in exactly one line — what it owns, not how it works internally.
6. State which architectural layer PaymentService belongs to and what role it plays there.
7. Name the single best next file to read to go one level deeper, with a one-line reason.

Write your output in this compact map format:
```
<target> — <one-line responsibility>
  exports:  <key public symbols>
  called by:
    <module A> — <why it calls in>
    <module B> — <why it calls in>
  depends on:
    <module C> — <what it needs downstream>
  fits: <which layer / subsystem, and the role it plays there>
```

End with: "Next: `<file path>` — <one-line reason>"
