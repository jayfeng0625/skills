Survey the codebase in the `inputs/` directory for deepening opportunities — shallow modules whose interface is nearly as complex as their implementation.

1. Read `inputs/CONTEXT.md` first to load the project's domain vocabulary (Ledger, LineItem, Workspace). Use these canonical names when describing candidates.
2. Check `inputs/docs/adr/` for documented decisions (degrade gracefully if absent).
3. Walk each TypeScript file in `inputs/` and decide: is the module Shallow (many small methods each wrap one implementation step, caller must know which to call) or Deep (one or two methods hide meaningful complexity)?
4. Apply the **deletion test** to each candidate you suspect is shallow: if you deleted this module and put its logic inline in each caller, would complexity concentrate in the callers, or just move there unchanged? A "concentrates" answer confirms shallowness.
5. For each genuine deepening opportunity: explain what makes it shallow, apply the deletion test, propose a specific refactor that reduces the public interface (show before/after method counts), and explain how the refactor reduces caller burden.
6. Explicitly avoid flagging modules that already hide meaningful complexity behind a small interface — call them out as already deep if you evaluated them and passed.

Write your entire analysis as structured text **in this conversation** — do not write to files. Use these vocabulary terms throughout: Module, Interface, Shallow, Deep, Seam, Leverage, Locality.
