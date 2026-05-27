# Weather API Client Library

## Problem/Feature Description

A data team needs to integrate with a third-party weather API that exposes several endpoints: current conditions by city, a 7-day forecast by coordinates, and historical weather data by date range. They want an API client library that their application code will use.

The team has found in the past that generic HTTP wrapper clients are hard to test — test setups become complicated because the mock has to conditionally handle different endpoints. They want a client library that is easy to mock in unit tests, with clear, specific interfaces for each weather operation.

Design and implement the weather API client library. Include example tests showing how the client would be used in tests.

## Output Specification

Produce the following files:

- `weatherClient.js` (or equivalent) — the API client implementation
- `weatherClient.test.js` (or equivalent) — example tests demonstrating how the client is tested
- `design-notes.md` — a brief document explaining the design of the client interface, specifically: why specific functions were chosen over a generic approach, and how the design makes each operation independently testable

The client should not require real API credentials to demonstrate its structure. Use placeholder base URLs and explain how authentication would be injected.
