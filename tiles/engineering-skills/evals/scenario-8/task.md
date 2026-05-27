# Rate Limiter with TDD Cycles Logged

## Problem/Feature Description

A backend team needs a rate limiter that can be used by their API middleware. The rate limiter should track how many requests a given client (identified by an API key) has made within a sliding time window, and reject further requests once the limit is reached.

Requirements: configurable request limit and time window (in seconds), support for multiple clients simultaneously, and the ability to reset a client's quota (for testing or admin purposes).

Implement this using test-driven development. Because the team wants to train junior developers on TDD, you should log your process in detail so it can be used as a teaching example.

## Output Specification

Produce the following files:

- `rateLimiter.js` (or equivalent) — the rate limiter implementation
- `rateLimiter.test.js` (or equivalent) — the complete test suite
- `tdd-cycles.md` — a detailed log of every RED→GREEN cycle, in order:
  - Which behavior you chose to test next (and why it was next)
  - The test you wrote
  - The minimal implementation you added to make it pass
  - Confirmation that the test passed

The rate limiter operates in memory and uses injected time (not `Date.now()` directly) so that tests can control the clock without real delays.
