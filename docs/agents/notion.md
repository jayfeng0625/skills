# Notion config

## Workspace

Hub page: bonAI.dev (id: 36c0ce95-22a0-8025-b90c-c83c8a967b02)
Container page: Bonai Skills (id: 36c0ce95-22a0-8167-8ef8-f58ab92e343a)

## Databases

Issues DB:           79c66f73-b091-481d-9c83-d1306ae8a10d   (data source: 4d6e13ca-c1fb-40b1-8e01-389ac8b2bff6)
PRDs DB:             eba39c09-8f85-4c9a-862c-f40241e0e307   (data source: f05ab07d-d31c-4108-ae13-f689d62c15c7)
Handoffs DB:         2f5b7141-db85-4a44-8810-8a41b49fe8e4   (data source: 34b80089-21b7-4448-b3a1-029254c1517d)
Domain Glossary DB:  ad745d13-35b7-4402-8523-6e85414951bc   (data source: 7545b1ff-aa91-4298-9af8-607be04827c6)
ADRs DB:             d487434f-b4d9-4049-8b5a-1d078717af6d   (data source: 7e0a76de-344e-4aa4-b27d-c1684ed113ce)

## Issues DB properties

Status (select):
  needs-triage     → "needs-triage"
  needs-info       → "needs-info"
  ready-for-agent  → "ready-for-agent"
  ready-for-human  → "ready-for-human"
  wontfix          → "wontfix"

Category (select):
  bug              → "bug"
  enhancement      → "enhancement"

Blocked by: relation → Issues DB (self; auto-synced as "Blocks")

## ADRs DB properties

Status (select): proposed / accepted / deprecated / superseded
Area (select): currently only a "placeholder" option — add per-area values as needed
Superseded by: relation → ADRs DB (self; auto-synced as "Supersedes")

## Domain Glossary DB properties

(no structured properties — page title = term, page body = definition)

## Handoffs DB properties

Date (date): default today
Epic (select): seeded with `Stage 2 design`; add new options in Notion as new workstreams begin. Required when calling `create handoff page`.
