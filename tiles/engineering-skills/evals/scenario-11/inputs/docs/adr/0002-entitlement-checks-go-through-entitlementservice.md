# Entitlement checks go through EntitlementService

## Status

Accepted.

## Decision

Whether a Subscriber holds an Entitlement is resolved **only** through `EntitlementService.allows(subscriberId, entitlement)`. Callers must never inspect a Plan's fields (its name, tier, or feature list) to infer access inline.

Granting and revoking are likewise centralized: `EntitlementService.grant(...)` and `EntitlementService.revoke(...)` are the only ways Entitlements change.

## Consequences

- Access logic lives in one place; product code asks the EntitlementService rather than reading Plan internals.
- Plan structure can change without touching every call site.
- Tests exercise access through `EntitlementService`, not by constructing Plans and reading their fields.
