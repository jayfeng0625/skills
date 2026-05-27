# Invoice Module Refactoring

## Problem/Feature Description

A billing team has a working invoice calculation module that was developed incrementally. All tests pass. Now the team has asked you to look at the code with fresh eyes and identify refactoring opportunities that would improve the design — making it easier to maintain, extend, and test.

The module is in `starter/invoice.js` and its tests are in `starter/invoice.test.js`. All tests are currently passing.

Your job is to propose and apply refactoring improvements. The tests must still pass after each change, and the behavior of the module must not change.

## Output Specification

Produce the following files:

- `invoice-refactored.js` — the refactored implementation
- `invoice-refactored.test.js` — the test suite (copied or adapted from starter — keep tests on the public interface)
- `refactor-log.md` — a record of each refactoring step taken, in order, with the rationale for each change

Each entry in `refactor-log.md` should note: what was changed, why it was a refactoring opportunity, and confirm that tests still passed after the step.
