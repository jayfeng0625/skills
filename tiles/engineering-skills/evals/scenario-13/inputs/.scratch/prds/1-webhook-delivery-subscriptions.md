# Webhook Delivery Subscriptions

> Backend: local · captured by /to-prd

## Problem Statement

Third-party developers can't get real-time notifications — they poll our REST API, which is slow, wastes quota, and misses short-lived state changes. Support can't see whether a customer's endpoint is reachable.

## Solution

Developers register an HTTPS endpoint, subscribe it to event types, and we POST a signed payload on each event — retrying with backoff and exposing delivery status.

## User Stories

1. As a developer, I want to subscribe an endpoint to chosen event types, so that I receive only the events I care about.
2. As a developer, I want to see a delivery's status including failures, so that I can tell whether my endpoint received an event.
3. As a developer, I want to replay a failed delivery, so that I can recover missed events without waiting for the next one.
4. As a developer, I want to rotate a subscription's signing secret, so that I can respond to a leak without downtime.
5. As a support engineer, I want to see a subscription's health, so that I can diagnose a customer's missed events.

## Implementation Decisions

1. **Event catalog ships as a committed seed list, merged ahead of per-tenant overrides.** Adding an event type is a code change, not config drift.
2. **Deliveries are signed with HMAC-SHA256.** Header `X-Signature: sha256=<hex>`, where `<hex>` is the lowercase hex HMAC-SHA256 of the raw request body keyed by the subscription secret.
3. **Retry is a fixed schedule of 5 attempts**, then the delivery is marked dead and the subscription flagged unhealthy.
4. **Secret rotation keeps old and new valid for a 24h overlap** so in-flight receivers don't break.
5. **Endpoints must be HTTPS and pass a one-time reachability ping** at registration; disabled subscriptions stop delivering but keep their log.
6. Delivery lifecycle (from a prototype):

```
pending ──▶ delivering ──▶ delivered
                ├──▶ failed ──▶ retrying ──▶ delivering   (attempts < 5)
                └──▶ failed ──▶ dead                       (attempts == 5)
```

Event catalog:

| event | payload | default-subscribed |
| --- | --- | --- |
| order.created | full order object | yes |
| order.refunded | order id + refund amount | yes |
| customer.updated | changed fields only | no |
| payout.settled | payout id + amount + period | no |

Backoff schedule: 1 min, 5 min, 30 min, 2 hr, 6 hr.

## Testing Decisions

Test external behavior: given an event, assert a signed POST is attempted and the delivery row reflects the right state. Cover retry exhaustion → dead, signature correctness, and secret-overlap acceptance. Don't assert on internal queue structure.

## Out of Scope

Inbound webhooks, a hosted UI dashboard, per-event-type rate limiting, delivery ordering guarantees.
