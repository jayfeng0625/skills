# User Repository Tests

## Problem/Feature Description

A backend team is building a `UserRepository` module that stores and retrieves user records. The repository wraps a database (SQLite for local development). The team wants a test suite for the repository that is clear, reliable, and maintainable.

A junior developer wrote a first pass of some tests, but the tech lead was unhappy — she said the tests were "looking behind the curtain" at the database instead of testing what the module actually promises its callers. She asked you to write the tests correctly.

Implement the `UserRepository` and its test suite. Use an in-memory SQLite instance (or a simple in-memory store) so tests can run without a real database server.

## Output Specification

Produce the following files:

- `userRepository.js` (or equivalent) — the repository implementation
- `userRepository.test.js` (or equivalent) — the test suite
- `design-notes.md` — a short explanation of what makes the tests verify through the interface rather than bypass it, and any interface design choices made for testability
