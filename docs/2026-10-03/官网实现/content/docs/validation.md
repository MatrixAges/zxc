### Verify the application boundary

Use the target application's documented build, check, and execution commands. Check all changed RX and ZX files, their transitive dependencies, and the actual business entry point.

- Every module reference resolves to a real file.
- Inputs and outputs agree at each call boundary.
- Dependencies remain acyclic.
- Normal, boundary, and failure behavior match the business contract.
- State ownership, concurrency, and retry behavior are explicit.

### Report evidence precisely

Distinguish static analysis, compilation, host execution, and business verification. A successful compiler build is not proof that an application ran.

If the runtime or checker is unavailable, state that limitation. Do not invent an execution command or substitute expected output for an actual run.

### Hand off a small report

List changed behavior and file responsibilities, commands actually run and their results, and unresolved requirements. Keep failures visible; do not remove required cases merely to obtain a passing result.
