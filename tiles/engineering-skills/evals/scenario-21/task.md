Look at the three TypeScript modules below and answer the three questions at the end. Write your answers in plain text — do not run any commands or write any files.

## Module A: workspaceRepository.ts

```typescript
import { db } from "./db";

export function findWorkspaceById(id: string): Promise<Workspace | null> {
  return db.query("SELECT * FROM workspaces WHERE id = $1", [id]).then(r => r.rows[0] ?? null);
}
export function findWorkspaceByStripeCustomerId(stripeId: string): Promise<Workspace | null> {
  return db.query("SELECT * FROM workspaces WHERE stripe_customer_id = $1", [stripeId]).then(r => r.rows[0] ?? null);
}
export function findWorkspaceByName(name: string): Promise<Workspace | null> {
  return db.query("SELECT * FROM workspaces WHERE name = $1", [name]).then(r => r.rows[0] ?? null);
}
export function createWorkspace(name: string, stripeId: string, plan: string): Promise<Workspace> {
  return db.query("INSERT INTO workspaces (name, stripe_customer_id, plan) VALUES ($1,$2,$3) RETURNING *", [name, stripeId, plan]).then(r => r.rows[0]);
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
```

## Module B: ledgerFormatter.ts

```typescript
export function formatAmount(minorUnits: number, currency: string): string {
  return new Intl.NumberFormat("en", { style: "currency", currency }).format(minorUnits / 100);
}
export function formatCategoryCode(code: string): string {
  return code.replace(/_/g, " ").toLowerCase();
}
export function formatDate(date: Date): string {
  return date.toISOString().slice(0, 10);
}
export function formatLineItemSummary(item: LineItem, currency: string): string {
  return `${item.description}: ${formatAmount(item.amount, currency)}`;
}
export function formatEntryTotal(entry: LedgerEntry, currency: string): string {
  return formatAmount(entry.total, currency);
}
export function formatEntryDescription(entry: LedgerEntry): string {
  return entry.description ?? "(no description)";
}
```

## Module C: lineItemValidator.ts

```typescript
export function validateLineItem(item: unknown): ValidationResult {
  const errors: string[] = [];
  const li = item as any;
  if (!Number.isInteger(li.amount) || li.amount <= 0) errors.push("amount must be a positive integer");
  if (li.amount > 100_000_000) errors.push("amount exceeds maximum");
  if (!li.description?.trim()) errors.push("description is required");
  if (li.description?.length > 280) errors.push("description too long");
  if (!li.categoryCode) errors.push("categoryCode is required");
  if (!ALLOWED_CATEGORIES.has(li.categoryCode)) errors.push("categoryCode not in allowed set");
  return { valid: errors.length === 0, errors };
}
```

---

Answer these three questions in order. Write your complete answer here in this chat response.

**Q1.** For Module A (workspaceRepository), does the module's public API hide complexity from its callers, or do callers need to know about each individual operation? Explain in 2-3 sentences.

**Q2.** For Module B (ledgerFormatter), same question: does it hide complexity, or do callers need to understand each individual formatting operation? Explain in 2-3 sentences.

**Q3.** For Module C (lineItemValidator), same question: does it hide complexity, or do callers need to understand the validation logic? Explain in 2-3 sentences, and note how it differs from Modules A and B.
