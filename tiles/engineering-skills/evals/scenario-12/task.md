# Webhook Delivery Subscriptions — write the PRD

A platform team has finished designing **webhook delivery subscriptions** and needs the design captured as a PRD. The design is already agreed — do **not** re-interview or wait for confirmation. Synthesize the notes below into a PRD and write it to the project's configured workflow tracker.

This repository has its agent configuration checked in (see the `## Agent skills` block in `CLAUDE.md`). Use the configured workflow backend to create the PRD.

## Agreed design notes

**Problem.** Third-party developers integrating with our platform have no way to receive real-time notifications. They poll our REST API on a timer, which is slow, wastes quota, and misses short-lived state changes. Support has no visibility into whether a customer's endpoint is even reachable. Finance can't attribute API load to polling vs. legitimate use.

**Solution.** Let a developer register an HTTPS endpoint and subscribe it to a set of event types. When a subscribed event occurs we POST a signed JSON payload to the endpoint, retrying on failure with backoff, and expose the delivery status.

**Event types** — the catalog a subscription can select from:

| event | payload | default-subscribed |
| --- | --- | --- |
| order.created | full order object | yes |
| order.refunded | order id + refund amount | yes |
| customer.updated | changed fields only | no |
| payout.settled | payout id + amount + period | no |

**Signing.** Every delivery carries header `X-Signature: sha256=<hex>` where `<hex>` is the lowercase hex HMAC-SHA256 of the raw request body keyed by the subscription's secret. Receivers recompute and compare to authenticate.

**Retry / backoff.** A delivery is attempted up to 5 times. Backoff between attempts is fixed: 1 min, 5 min, 30 min, 2 hr, 6 hr. After the 5th failed attempt the delivery is marked dead and the subscription is flagged unhealthy.

**Delivery state machine** — lifted from a throwaway prototype we built to sanity-check the transitions:

```
pending ──▶ delivering ──▶ delivered
                │
                ├──▶ failed ──▶ retrying ──▶ delivering   (attempts < 5)
                └──▶ failed ──▶ dead                       (attempts == 5)
```

**Secret rotation.** A developer can rotate a subscription's secret. Both old and new secret are accepted for a 24-hour overlap so in-flight receivers don't break.

**Storage.** Subscriptions and their delivery log live in our primary datastore. The event catalog above ships as a committed seed list merged ahead of any per-tenant overrides, so adding a new event type is a code change, not config drift.

**Validation.** Endpoint URLs must be HTTPS. A subscription is rejected if its endpoint fails a one-time reachability ping at registration. Disabled subscriptions stop receiving deliveries but retain their log.

**People who care.** Third-party developers integrating against us; our support engineers diagnosing a customer's missed events; platform engineers operating the delivery pipeline. Developers variously want to: subscribe an endpoint to events; see whether a given delivery succeeded; find out when a delivery has failed; replay a failed delivery; rotate the signing secret.

**Not now.** Inbound webhooks (us receiving), a hosted UI dashboard, per-event-type rate limiting, and webhook delivery ordering guarantees are all explicitly deferred.

## Output

Write the PRD to the configured tracker. Do not produce code.
