# Design Proposal: Notification Service Refactor

## Background

Our current notification system sends emails, Slack messages, and push notifications from scattered places throughout the codebase. Every feature team has its own notification logic. This means duplicated templates, inconsistent retry behavior, and no central monitoring.

## Proposed Design

Extract all notification logic into a dedicated `NotificationService` class. All notification sending goes through this single service. Teams register templates centrally.

## Key Decisions

- **Transport layer**: Use an adapter pattern — one adapter per channel (email, Slack, push)
- **Retry policy**: Exponential backoff, max 3 retries
- **Template storage**: Templates live in the database (not files)
- **Async vs sync**: All notifications sent async via a job queue
- **Error handling**: Failed notifications logged to `notification_errors` table; no re-raises

## Unknowns

- Whether existing callers can be migrated without breaking changes
- How to handle notification preferences per user (opt-out logic)

## Status

This is a pre-implementation proposal. No code has been written yet.
