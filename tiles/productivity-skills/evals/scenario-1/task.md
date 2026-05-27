# Invoice Processing Skill

## Problem/Feature Description

A finance operations team handles invoices from dozens of vendors, each with subtly different formats, approval chains, and GL coding rules. They've been relying on tribal knowledge: one person knows the European VAT handling rules, another knows the three-way match process, another knows the escalation thresholds by region. When any of these people are unavailable, work grinds to a halt.

The team wants to capture all of this as an agent skill. The domain is genuinely large: there are standard invoice processing workflows, vendor-specific quirks, multi-currency handling, GL coding conventions for different cost centers, audit trail requirements, exception handling for disputes and partial deliveries, and escalation rules for high-value invoices. Some of this is needed every time an invoice is processed; the rest is edge-case material that most agents will rarely need.

The skill should help agents process invoices end-to-end — from receipt and validation through approval routing and final posting. It should handle the common cases quickly and guide agents through the edge cases when they arise.

## Output Specification

Create the full skill directory structure under `invoice-processor/`. The skill should be organized so the main file stays focused and readable, with details available for agents that need them.

Write a `design-notes.md` explaining which content you put where and what drove your structural decisions.
