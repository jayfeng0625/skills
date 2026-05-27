# Notification Service Feature

## Problem/Feature Description

A SaaS product team needs a `NotificationService` that dispatches in-app notifications to users. The service must support at minimum: creating a notification, marking it as read, and fetching all unread notifications for a user. The team works in TypeScript.

The project already has its development environment configured. The relevant project documentation is at `docs/agents/commands.md` — read it before starting.

Using test-driven development, implement this service and its tests. Document your process in a short log file. The implementation should be entirely in-memory (no real database or external service calls are needed).

## Output Specification

Produce the following files:

- `notificationService.ts` — the implementation
- `notificationService.test.ts` — the test suite
- `tdd-log.md` — a record of your RED→GREEN cycles, listing which test you wrote, then which implementation you added, in order

All test runs and type-check commands invoked during your process must be recorded in `tdd-log.md`.
