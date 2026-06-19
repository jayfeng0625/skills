Analyze the three TypeScript modules below for deepening opportunities. Use the modules and domain glossary provided — no file reads required. Write your analysis as plain text in this response — do NOT write to files or produce HTML.

## Domain Glossary

**Ledger** — the append-only store of all financial transactions for a workspace. Immutable once written.
**LineItem** — a single charge or credit within a transaction: amount (integer minor units), description, category code.
**Workspace** — the top-level billing tenant. One workspace maps to one Stripe customer.

## Module 1: workspaceRepository.ts

```ts
import { db } from "./db";

export function findWorkspaceById(id: string): Promise<Workspace | null> {
  return db.query("SELECT * FROM workspaces WHERE id = $1", [id]).then(r => r.rows[0] ?? null);
}
export function findWorkspaceByStripeCustomerId(stripeCustomerId: string): Promise<Workspace | null> {
  return db.query("SELECT * FROM workspaces WHERE stripe_customer_id = $1", [stripeCustomerId]).then(r => r.rows[0] ?? null);
}
export function findWorkspaceByName(name: string): Promise<Workspace | null> {
  return db.query("SELECT * FROM workspaces WHERE name = $1", [name]).then(r => r.rows[0] ?? null);
}
export function createWorkspace(name: string, stripeCustomerId: string, plan: string): Promise<Workspace> {
  return db.query("INSERT INTO workspaces (name, stripe_customer_id, plan) VALUES ($1,$2,$3) RETURNING *", [name, stripeCustomerId, plan]).then(r => r.rows[0]);
}
export function updateWorkspacePlan(id: string, plan: string): Promise<Workspace> {
  return db.query("UPDATE workspaces SET plan = $2 WHERE id = $1 RETURNING *", [id, plan]).then(r => r.rows[0]);
}
export function updateWorkspaceName(id: string, name: string): Promise<Workspace> {
  return db.query("UPDATE workspaces SET name = $2 WHERE id = $1 RETURNING *", [id, name]).then(r => r.rows[0]);
}
export function updateWorkspaceTrialEndsAt(id: string, trialEndsAt: Date | null): Promise<Workspace> {
  return db.query("UPDATE workspaces SET trial_ends_at = $2 WHERE id = $1 RETURNING *", [id, trialEndsAt]).then(r => r.rows[0]);
}
export function deleteWorkspace(id: string): Promise<void> {
  return db.query("DELETE FROM workspaces WHERE id = $1", [id]).then(() => undefined);
}
// 8 exported functions — each wraps a single DB call. Callers must know and call each one individually.
```

## Module 2: ledgerFormatter.ts

```ts
export function formatAmount(amountMinorUnits: number, currencyCode: string): string {
  return new Intl.NumberFormat("en", { style: "currency", currency: currencyCode }).format(amountMinorUnits / 100);
}
export function formatCategoryCode(code: string): string {
  return code.replace(/_/g, " ").toLowerCase();
}
export function formatDate(date: Date): string {
  return date.toISOString().slice(0, 10);
}
export function formatLineItemSummary(item: LineItem, currencyCode: string): string {
  return `${item.description}: ${formatAmount(item.amount, currencyCode)}`;
}
export function formatEntryTotal(entry: LedgerEntry, currencyCode: string): string {
  return formatAmount(entry.total, currencyCode);
}
export function formatEntryDescription(entry: LedgerEntry): string {
  return entry.description ?? "(no description)";
}
// 6 exported functions — each is a trivial 1-2 line formatter. Callers import and call each one individually.
```

## Module 3: lineItemValidator.ts

```ts
export function validateLineItem(item: unknown): ValidationResult {
  const errors: string[] = [];
  const li = item as Partial<LineItem>;
  if (!Number.isInteger(li.amount) || (li.amount ?? 0) <= 0) errors.push("amount must be a positive integer");
  if ((li.amount ?? 0) > 1_000_000_00) errors.push("amount exceeds maximum");
  if (!li.description || li.description.trim() === "") errors.push("description is required");
  if ((li.description?.length ?? 0) > 280) errors.push("description too long");
  if (!li.categoryCode) errors.push("categoryCode is required");
  if (li.categoryCode && !ALLOWED_CATEGORIES.has(li.categoryCode)) errors.push("categoryCode not allowed");
  return { valid: errors.length === 0, errors };
}
// 1 exported function hiding 6 validation rules + error aggregation.
// Callers call ONE function and get a typed ValidationResult back.
```

---

This is a read-only written assessment. Do not edit, refactor, or rewrite any code — write your entire answer as plain text in this response.

For EACH of the three modules, write this exact compact report block:

```
<module> — Shallow | Deep
  why: <one line — is the Interface nearly as complex as the implementation, or does a small Interface hide meaningful complexity?>
  deletion test: <if Shallow: would inlining concentrate complexity in callers (confirms shallow) or just move it?>
  what a deepening would look like: <if Shallow: describe the smaller interface in words, e.g. "8 methods collapse to 2 — find(criteria) and save(workspace)"; if Deep: "none — already deep">
```

Rules:
- Use the vocabulary terms: **Module, Interface, Shallow, Deep, Seam, Leverage, Locality**.
- Use domain glossary terms where relevant: Ledger, LineItem, Workspace.
- Exactly one of the three modules is already Deep — mark it `Deep` and write `what a deepening would look like: none — already deep`.

End with: "Tackle first: `<module>` — <one-line reason>"
