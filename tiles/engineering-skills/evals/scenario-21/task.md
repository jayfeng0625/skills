Survey the codebase in the inputs/ directory for deepening opportunities and produce an architectural improvement report.

Use the improve-codebase-architecture skill. Read CONTEXT.md first to ground your analysis in the project's domain vocabulary. Check docs/adr/ for any documented decisions that should constrain your suggestions (degrade gracefully if the directory is absent).

For each candidate you identify, explain what makes it shallow, propose a specific refactor that reduces interface complexity, and show a before/after comparison. Produce the output as an HTML report written to the OS temp directory.

Do not flag modules whose interface already hides meaningful complexity — only surface genuine deepening opportunities.
