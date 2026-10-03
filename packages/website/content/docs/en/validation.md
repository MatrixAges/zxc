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

### Match evidence to the claim

| Check                    | Supports                                  | Does not establish                        |
| ------------------------ | ----------------------------------------- | ----------------------------------------- |
| `zxc fmt ... --check`    | Source matches formatter output           | Type safety or execution                  |
| ZX compilation           | Parsing, semantic checks, generated Zig   | Host integration or business correctness  |
| Host build               | Generated code integrates with that build | All runtime paths behave correctly        |
| Host execution           | Observed behavior for supplied inputs     | Behavior of unexecuted paths              |
| RX structural validation | Tag and module graph constraints          | XML loading, scheduling, or state commits |

### Suggested handoff

```text
Behavior: <what changed>
Files: <each responsibility>
Toolchain: <revision and Zig version>
Verified: <actual commands and observed results>
Host boundary: <memory, I/O, and state assumptions>
Remaining: <unimplemented or unverified behavior>
```

If a diagnostic blocks compilation, use [resolve diagnostics](/docs/troubleshooting). If code compiles but cannot run, check [host integration](/docs/host-integration).
