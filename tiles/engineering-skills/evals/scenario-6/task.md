# Email Notification Service Interface

## Problem/Feature Description

A platform team needs to add email notifications to their application. The service will need to send transactional emails (e.g. welcome email, password reset) via an external email provider (such as SendGrid or Mailgun). The team is about to start implementing this with TDD.

Before any code is written, the tech lead wants a clear interface design document and a reference implementation skeleton that demonstrates the interface choices made.

Your job is to design the interface for the `EmailService` and produce a working skeleton implementation. Focus on making the interface easy to test and easy to use — not on the internal email-sending logic.

## Output Specification

Produce the following files:

- `emailService.js` (or equivalent) — the interface skeleton (can throw NotImplemented errors for the internals, but the interface should be complete)
- `emailService.test.js` (or equivalent) — example tests showing how the service would be tested
- `interface-design.md` — a short document explaining each interface decision made for testability, with the alternative you considered and why you chose this design

Focus on how the service accepts its dependencies, what it returns, and how many public methods it exposes.
