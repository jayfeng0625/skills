// LedgerFormatter — formats Ledger entries for display.
// This module is SHALLOW in a different way: the interface is more complex
// than the implementation. Each exported function wraps 1-2 lines of logic
// that callers could inline just as easily.

export interface LineItem {
  amount: number; // integer minor units
  description: string;
  categoryCode: string;
}

export interface LedgerEntry {
  id: string;
  workspaceId: string;
  lineItems: LineItem[];
  createdAt: Date;
}

// Exported individually, but each is a trivial one-liner.
// Callers have to import and call each formatter separately,
// knowing exactly which one applies for each field.

export function formatAmount(amountMinorUnits: number, currencyCode: string): string {
  return (amountMinorUnits / 100).toFixed(2) + " " + currencyCode.toUpperCase();
}

export function formatCategoryCode(code: string): string {
  return code.replace(/_/g, " ").toLowerCase();
}

export function formatDate(date: Date): string {
  return date.toISOString().split("T")[0];
}

export function formatLineItemSummary(item: LineItem, currencyCode: string): string {
  return `${formatCategoryCode(item.categoryCode)}: ${formatAmount(item.amount, currencyCode)}`;
}

export function formatEntryTotal(entry: LedgerEntry, currencyCode: string): string {
  const total = entry.lineItems.reduce((sum, item) => sum + item.amount, 0);
  return formatAmount(total, currencyCode);
}

export function formatEntryDescription(entry: LedgerEntry): string {
  return entry.lineItems.map((item) => item.description).join(", ");
}
