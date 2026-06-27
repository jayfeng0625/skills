# Money is represented as integer minor units

## Status

Accepted.

## Decision

All monetary amounts in this service are represented as **integer minor units** (e.g. cents for USD), never as floating-point numbers or decimal dollars. A `$5.00` discount is `500`. Currency is carried alongside the amount as an ISO-4217 code.

## Consequences

- Interfaces that accept or return money take/return integers, never floats or formatted strings.
- Rounding bugs from float arithmetic are designed out: arithmetic happens on integers.
- Formatting to a human-readable string happens only at the presentation boundary, never in the billing core.
