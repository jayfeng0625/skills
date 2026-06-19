We've been debugging a webhook retry bug for the past hour. Here's what we know so far:

- Webhook deliveries fail silently after attempt 2 — the retry counter never increments past 2, and the delivery never reaches the dead state.
- Tracing through the delivery pipeline, it looks like the retry counter resets to 0 on service restart rather than persisting. This means any in-flight retries are silently abandoned when the service restarts (which happens during deploys).
- We haven't yet identified which module owns the retry counter or confirmed where it's stored (in-memory vs. persistent store).
- We haven't written any fixes or tests yet.

The work is paused and a different session will need to pick this up. Write a handoff so the next session can resume debugging without losing context. Use the configured workflow backend (see CLAUDE.md).
