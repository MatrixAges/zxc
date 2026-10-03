### Implemented in the current repository

- ZX parsing, type and ownership checks, IR validation, and Zig emission.
- Multi-file imports and acyclic import checking.
- RX tag definitions, file-path module registration, and dependency cycle checks.
- Store access contracts at the compiler boundary, with host-provided commit behavior.

### Not a production runtime

A complete RX XML loader and production scheduling runtime are not included in the compiler. Database support is not implemented. Store version checks, locks, persistence, and cross-object atomic publication remain host responsibilities.

Do not present Gateway or Store declarations as proof of a running HTTP server or persistent database.

### Version boundaries

The repository package version is **0.0.1**. The ZX language contract is **0.1.0** and its IR is experimental **version 2**. The IR is an in-memory Zig API, not a stable serialized interchange format.

This documentation is a snapshot of the current source, not a compatibility promise. Consult the installed revision and host contracts before using a feature described in a design document.

### Design goals and work ahead

- **AI graph collaboration**: dependency analysis and acyclicity checks exist. Exposing relationships directly to AI for context selection, tracing, and impact analysis is an interface direction. No stable graph query or export protocol is promised today.
- **Model quality and token efficiency**: the goal is to reduce cognitive and context burden so non-SOTA models can meet the same code quality standards as SOTA models. No comparative evaluation result is established here.
- **Zero-cost abstractions**: atomic logic, static contracts, and Zig compilation provide an optimization foundation. Not every abstraction has had its overhead eliminated; some collection operations still allocate.
- **LLVM and assembly**: the current zxc backend emits Zig. Choosing Zig’s LLVM backend enables further target optimization and machine-code generation. This is not a direct zxc LLVM backend or a dedicated assembly command.
- **Formal proofs and FPGA**: these are long-term research directions. The former needs formal semantics, specifications, and proof tools; the latter needs a synthesizable computation subset, hardware constraints, and a dedicated synthesis backend. LLVM support alone does not deliver either capability.
