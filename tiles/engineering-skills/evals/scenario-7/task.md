# Config Loader Module Deepening

## Problem/Feature Description

A platform team has a configuration loading utility in `inputs/configLoader.js`. It is used across many services to load and validate JSON config files. However, every caller has to repeatedly call multiple functions in the right sequence and pass the raw config object around, knowing its internal structure.

The team has started to notice that callers are fragile — when the config format changes, many files break. The tech lead says the module is "too shallow" — its interface is nearly as complex as the callers themselves, and it provides little protection.

Your job is to redesign and reimplement the config loader as a deep module: a smaller public interface that hides the complexity that callers currently have to manage themselves, while still supporting all the use cases.

## Output Specification

Produce the following files:

- `configLoader-v2.js` — the redesigned deep module implementation
- `configLoader-v2.test.js` — tests for the new interface (test through the new public interface only)
- `design-rationale.md` — a short document explaining: what made the original module shallow, what interface decisions you made to deepen it, and specifically how the number of methods and parameter complexity changed

Callers of the new module should be able to load and access typed config values with fewer method calls and without needing to pass the raw config object around between calls.
