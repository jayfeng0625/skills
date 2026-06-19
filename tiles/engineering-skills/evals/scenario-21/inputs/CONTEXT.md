# Domain Glossary

**Ledger** — the append-only store of all financial transactions for a workspace. Immutable once written; never updated in place.

**LineItem** — a single charge or credit within a transaction, carrying an amount (integer minor units), a description, and a category code. The smallest unit of billing detail visible to end users.

**Workspace** — the top-level billing tenant. One workspace maps to one Stripe customer. All Ledger entries and LineItems belong to a workspace.
