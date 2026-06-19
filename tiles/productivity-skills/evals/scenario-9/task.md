We've been debugging a webhook retry bug for the past hour. Here's what we know so far:

- Webhook deliveries fail silently after the second attempt
- The retry counter resets on service restart, causing infinite retry loops
- We've traced it to the delivery pipeline's state machine but haven't confirmed the exact line yet
- The fix likely involves persisting the retry counter to the database between restarts

The context window is getting full and another agent will continue this work. Write a handoff document so the next session can pick up immediately.

Use "Webhook Debugging" as the Epic for this handoff.
