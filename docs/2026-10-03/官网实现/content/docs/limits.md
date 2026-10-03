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
