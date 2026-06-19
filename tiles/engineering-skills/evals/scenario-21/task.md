Analyze the three TypeScript modules below for deepening opportunities. Use the modules and domain glossary provided — no file reads required. Write your analysis as plain text in this response — do NOT write to files or produce HTML.

## Domain Glossary

**Ledger** — the append-only store of all financial transactions for a workspace. Immutable once written.
**LineItem** — a single charge or credit within a transaction: amount (integer minor units), description, category code.
**Workspace** — the top-level billing tenant. One workspace maps to one Stripe customer.

## Module 1: workspaceRepository.ts

```ts
import { db } from "./db";

export function findWorkspaceById(id: string): Promise<Workspace | null> { ... }
export function findWorkspaceByStripeCustomerId(stripeCustomerId: string): Promise<Workspace | null> { ... }
export function findWorkspaceByName(name: string): Promise<Workspace | null> { ... }
export function createWorkspace(name: string, stripeCustomerId: string, plan: string): Promise<Workspace> { ... }
export function updateWorkspacePlan(id: string, plan: string): Promise<Workspace> { ... }
export function updateWorkspaceName(id: string, name: string): Promise<Workspace> { ... }
export function updateWorkspaceTrialEndsAt(id: string, trialEndsAt: Date | null): Promise<Workspace> { ... }
export function deleteWorkspace(id: string): Promise<void> { ... }
// 8 exported functions — each wraps a single DB call. Callers must know and call each one individually.
```

## Module 2: ledgerFormatter.ts

```ts
export function formatAmount(amountMinorUnits: number, currencyCode: string): string { ... }
export function formatCategoryCode(code: string): string { ... }
export function formatDate(date: Date): string { ... }
export function formatLineItemSummary(item: LineItem, currencyCode: string): string { ... }
export function formatEntryTotal(entry: LedgerEntry, currencyCode: string): string { ... }
export function formatEntryDescription(entry: LedgerEntry): string { ... }
// 6 exported functions — each is a trivial 1-2 line formatter. Callers import and call each one individually.
```

## Module 3: lineItemValidator.ts

```ts
export function validateLineItem(item: unknown): ValidationResult {
  // Runs 6 validation rules: amount must be positive integer within bounds,
  // description non-empty within length limit, categoryCode in allowed set.
  // Aggregates all errors into a typed result.
  // Callers call ONE function and get a typed ValidationResult back.
}
// 1 exported function hiding 6 validation rules + error aggregation.
```

---

For EACH of the three modules, produce this exact compact format:

```
<module> — Shallow | Deep
  why: <one line — is the Interface nearly as complex as the implementation, or does a small Interface hide meaningful complexity?>
  deletion test: <if Shallow: would inlining concentrate complexity in callers (confirms shallow) or just move it?>
  refactor: <if Shallow: concrete before/after, e.g. "8 methods → 2 (find/save)"; if Deep: "none — already deep">
```

Rules:
- Use the vocabulary terms: **Module, Interface, Shallow, Deep, Seam, Leverage, Locality**.
- Use domain glossary terms where relevant: Ledger, LineItem, Workspace.
- Exactly one of the three modules is already Deep — mark it `Deep` and write `refactor: none — already deep`. Do not propose a refactor for it.

End with: "Tackle first: `<module>` — <one-line reason>"
