# Order Payment Integration Tests

## Problem/Feature Description

A fintech team is building an order processing system that integrates with an external payment provider (e.g. Stripe or similar). They need a `processOrder` function that validates an order, charges the customer, and marks the order as paid. The engineering lead has asked you to write a well-structured test suite for this function.

The payment provider has its own SDK that makes real HTTP calls when invoked. The test suite must be runnable in CI without real API credentials and without hitting live endpoints. The broader business logic (order validation, total calculation) lives in internal modules that the team owns.

Your goal is to write the tests and any supporting code (the `processOrder` implementation and a mock or stub for the payment provider) that make the tests runnable without network access.

## Output Specification

Produce the following files:

- `processOrder.js` (or equivalent) — the implementation of `processOrder`, accepting its dependencies as parameters
- `processOrder.test.js` (or equivalent) — the test suite
- `api.js` (or equivalent) — the interface definition for the payment provider client

The tests must be runnable offline. Include a brief `README.md` explaining how to run them.
