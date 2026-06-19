Survey the codebase in the inputs/ directory for deepening opportunities.

Use the improve-codebase-architecture skill. Read CONTEXT.md first to ground your analysis in the project's domain vocabulary. Check docs/adr/ for any documented decisions that should constrain your suggestions (degrade gracefully if the directory is absent).

For each candidate you identify, explain what makes it shallow, apply the deletion test to justify why it is worth deepening, propose a specific refactor that reduces interface complexity, and show before/after interface counts. Write your findings as a structured text analysis directly in this conversation — do not write to external files.

Do not flag modules whose interface already hides meaningful complexity — only surface genuine deepening opportunities.
