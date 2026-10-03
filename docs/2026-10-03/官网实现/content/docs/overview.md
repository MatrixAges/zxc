zxc is a programming language and compiler designed for agents. It separates application structure from computation:

- **RX** (`.rx`): XML that describes orchestration and explicit module boundaries.
- **ZX** (`.zx`): a constrained, TypeScript-like language for statically checked business logic.

A module has one responsibility. A file path is its identity. Data crosses boundaries through explicit inputs and outputs. Dependency cycles are rejected.

Start with [capabilities and limits](#capabilities). A language design is not a promise that every feature has a runtime implementation.
