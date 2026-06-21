# Triage: webhook deliveries silently drop after the first retry

Users are reporting that webhook endpoints miss events sporadically. After some investigation in the logs, it looks like the delivery pipeline retries once on failure but then stops — deliveries are never reaching the `dead` state even after repeated failures; they just disappear from the queue after the second attempt.

This repository has its agent configuration checked in (see the `## Agent skills` block in `CLAUDE.md`). Use the configured workflow backend to create the issue.

Investigate, identify the likely root cause, write a TDD fix plan, and publish the issue to the tracker. Do not produce application code.
