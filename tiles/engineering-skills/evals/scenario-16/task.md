I just joined this team and need orientation on the `PaymentService` module. Map it for me by following these steps:

1. Read `inputs/CONTEXT.md` first to load domain vocabulary (Payment, PaymentMethod, Order, Cart).
2. Read `inputs/src/payments/PaymentService.ts` — that's your anchor module.
3. List only its publicly exported names (functions, types, interfaces) — skip private internals.
4. Read the other TypeScript files in `inputs/src/` to find which ones import `PaymentService`. List each caller with its file path.
5. Write one line per neighbour (callers + downstream deps) describing what it owns — not how it works.
6. State which architectural layer PaymentService belongs to and what role it plays there.
7. Name the single best next file to read to go one level deeper, with a one-line reason.

Output in this compact map format:
```
PaymentService — <one-line responsibility>
  exports:  <key public symbols>
  called by:
    <file path> — <why it calls in>
    <file path> — <why it calls in>
  depends on:
    <interface/dep> — <what it needs downstream>
  fits: <architectural layer and role>
```

Use `inputs/` as the file path prefix for all callers and dependencies you list.

End with: "Next: `<file path>` — <one-line reason>"
