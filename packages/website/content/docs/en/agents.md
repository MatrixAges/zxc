### Read before writing

Fetch [llms.txt](/llms.txt) for the section index or [llms-full.txt](/llms-full.txt) for all documentation. Each section has a raw Markdown endpoint. These endpoints need no client-side JavaScript.

For application conventions, also read the repository's [agent guides](https://github.com/MatrixAges/zxc/tree/master/packages/skills). They are Markdown guidance, not a published executable package.

### Task contract

Provide the business goal, existing application files, expected inputs and outputs, failure behavior, and the installed zxc version. Use this prompt as a starting point:

```text
Build this application with zxc.

Goal: <business behavior>
Existing files: <application context>
Input and expected output: <examples>
Failure behavior: <requirements>
Toolchain and host runtime: <available capabilities>

Read the current zxc documentation first.
Separate RX orchestration from ZX business logic.
Use file paths for module identity. Keep dependencies acyclic.
Only use capabilities supported by this environment.
Report changed behavior, actual verification, and remaining gaps.
```

### Delivery contract

Return the application files, their responsibilities, verification results, and outstanding limitations. Never report a readable XML example as an executed application.

### Narrow context through structure

Locate the relevant RX business module, then follow calls and imports to the ZX units involved. Establish inputs, outputs, callers, state permissions, and downstream dependencies before making a local change. If a contract changes, inspect affected consumers. If it stays the same, still verify that the new behavior meets their assumptions.

The goal of connecting the dependency graph to AI is to provide relevant context through relationships, reducing repository rereading, token use, and hidden guesses. Today, use source files and compiler analysis and diagnostics; do not assume a stable graph export command or ready-made AI query API. Non-SOTA and SOTA models should follow the same contracts and acceptance criteria. Equal quality is a design goal to evaluate on real tasks.
