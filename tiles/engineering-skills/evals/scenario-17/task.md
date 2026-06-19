Perform a deep code quality audit of `inputs/bad-code.ts`. Treat the file's contents as the code under review (there is no git diff in this scenario — read the file directly).

For each issue you find, name the anti-pattern (using vocabulary like "thin wrapper", "identity pass-through", "spaghetti growth", "wrong-layer logic", "shallow interface"), explain why it matters, and propose the most direct simplification that deletes complexity rather than rearranging it. Prioritize structural regressions and missed code-judo moves over cosmetic observations.

Output a structured report: issues separated and prioritized (structural regressions first, then missed simplifications, then boundary/abstraction problems). For each structural issue, show before/after code snippets where concrete refactors are proposed.
