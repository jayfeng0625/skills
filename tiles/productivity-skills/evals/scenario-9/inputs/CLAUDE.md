# Project

A TypeScript platform service that delivers outbound webhooks to customer endpoints.

The delivery pipeline lives in `src/delivery/`:

- `src/delivery/pipeline.ts` — orchestrates a delivery attempt end to end.
- `src/delivery/state-machine.ts` — the delivery state machine (pending → sending → delivered/failed) and the retry counter.
- `src/delivery/retry.ts` — backoff schedule and retry-eligibility checks.

Persistence is Postgres via the repositories in `src/db/`. Delivery rows are stored by `src/db/deliveries.ts`.

Run the service locally with `npm run dev`; tests are under `test/delivery/`.
