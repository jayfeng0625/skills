---
name: tdd
description: Implements features or fixes bugs by writing a failing test first (red), making it pass with minimal code (green), then refactoring — driving design through external behavior tests. Reads test/lint/build commands from `docs/agents/commands.md` so it stays language-agnostic. Use when the user says "do this TDD", "test-first", "red-green-refactor", "write the test first", "integration tests", "build with tests", or asks for test-driven development of a feature or fix.
---

# Test-Driven Development

## Core principle

Tests verify behavior through public interfaces. The warning sign of an implementation-coupled test: it breaks during refactor when behavior hasn't changed. See [tests.md](tests.md) for good/bad examples and [mocking.md](mocking.md) for when mocking is appropriate.

## Commands

This skill never names a test runner directly. The canonical commands live in `docs/agents/commands.md`, written by `/setup-bonai-skills`:

- Run the test suite with `test_command`.
- Run the type-checker with `typecheck_command` (if set).

If `docs/agents/commands.md` is missing, stop and ask the user to run `/setup-bonai-skills` — do not invent a command from `package.json`.

## Anti-pattern: horizontal slices

**Never write all tests first, then all implementation.** Tests written in bulk test imagined behavior — they pass when real behavior breaks. Go vertical: `test1 → impl1`, `test2 → impl2`. Each test responds to what you learned from the previous cycle.

## Workflow

### 1. Planning

When exploring the codebase, ground test names and interface vocabulary in the project's domain language, and respect documented architectural decisions. The pointers to the glossary and ADR sources live in CLAUDE.md / AGENTS.md under the `## Agent skills` section's **Domain language** entry, written by `/setup-bonai-skills`. If that entry is missing, the project hasn't been set up — proceed without grounding rather than guessing where the sources live.

Before writing any code:

- [ ] Confirm with user what interface changes are needed
- [ ] Confirm with user which behaviors to test (prioritize)
- [ ] Identify opportunities for [deep modules](deep-modules.md) (small interface, deep implementation)
- [ ] Design interfaces for [testability](interface-design.md)
- [ ] List the behaviors to test (not implementation steps)
- [ ] Get user approval on the plan

Ask: "What should the public interface look like? Which behaviors are most important to test?"

**You can't test everything.** Confirm with the user exactly which behaviors matter most. Focus testing effort on critical paths and complex logic, not every possible edge case.

### 2. Tracer Bullet

Write ONE test that confirms ONE thing about the system end-to-end:

```python
# RED — test fails because checkout() doesn't exist yet
def test_user_can_checkout_with_valid_cart():
    cart = Cart([Item(sku="abc", price=10)])
    order = checkout(cart, payment=ValidCard())
    assert order.status == "confirmed"
    assert order.total == 10
```

Then write the minimal `checkout()` needed to turn it GREEN. Don't add the discount logic, don't add tax, don't add empty-cart handling — those are the next tests.

### 3. Incremental Loop

For each remaining behavior:

```
RED:   Write next test → fails
GREEN: Minimal code to pass → passes
```

Rules:

- One test at a time
- Only enough code to pass current test
- Don't anticipate future tests
- Keep tests focused on observable behavior

### 4. Refactor

After all tests pass, look for [refactor candidates](refactoring.md):

- [ ] Extract duplication
- [ ] Deepen modules (move complexity behind simple interfaces)
- [ ] Apply SOLID principles where natural
- [ ] Consider what new code reveals about existing code
- [ ] Run tests after each refactor step

**Never refactor while RED.** Get to GREEN first.

## Checklist Per Cycle

```
[ ] Test describes behavior, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
```
