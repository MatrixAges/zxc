The CLI compiles ZX to Zig and formats ZX source. Build from the repository to obtain `zig-out/bin/zxc`, or use `zxc` if you have put that binary on `PATH`.

### Compile

```sh
zig-out/bin/zxc packages/compiler/examples/quote.zx --out /tmp/quote.zig
```

| Argument       | Meaning                              |
| -------------- | ------------------------------------ |
| Input path     | The entry `.zx` file                 |
| `--out <path>` | Destination for generated Zig source |
| `--help`       | Print CLI usage                      |

Compilation includes import analysis and the compiler's semantic checks. Output is Zig source, not an executable, web server, or deployment package. Resolve the generated `zx_runtime` import when building it into a host.

### Format

```sh
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --check
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --write
```

| Mode      | Effect                                                            |
| --------- | ----------------------------------------------------------------- |
| No flag   | Print formatted source to standard output                         |
| `--check` | Compare source with formatted output; status 1 means a difference |
| `--write` | Replace the source file with formatted output                     |

Use check mode in an existing verification process. Use write mode when modifying the source is intentional.

### Paths and environment

Relative imports resolve from their importing file. `@/` imports resolve from the CLI working directory. Run commands from a deliberate project root so the same import has the same meaning locally and in automation.

### Commands that do not exist

There is no general `zxc run`, `zxc check`, `zxc watch`, or `zxc server` command in this CLI, and no RX XML execution command. `zig build zx-example` is a repository build step, not a zxc subcommand.

Continue with [diagnostics](/docs/troubleshooting) or [Zig host integration](/docs/host-integration).
