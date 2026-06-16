# Coupon Code Module

## Problem/Feature Description

A commerce team needs a small `CouponCode` module that validates and applies discount codes to an order subtotal. It must support: percentage discounts (e.g. 10% off), fixed-amount discounts (e.g. $5 off), rejecting expired codes, and rejecting codes below a minimum-spend threshold. The team works in TypeScript and builds this with test-driven development.

This repository already has its agent configuration checked in — the canonical commands for running tests and type-checking are recorded as part of that configuration. Use the repository's configured commands when you run tests and type-checks; do not guess a command or read one off `package.json` directly.

The module is entirely in-memory — no database or external service calls.

## Output Specification

Produce the following files:

- `couponCode.ts` — the implementation
- `couponCode.test.ts` — the test suite
- `tdd-log.md` — a record of your RED→GREEN cycles. For every test run and type-check you perform, record the **exact command string** you invoked.

All test and type-check commands invoked during your process must appear verbatim in `tdd-log.md`.
