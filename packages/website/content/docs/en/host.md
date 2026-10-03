Generated Zig runs inside a host that supplies runtime support and memory lifetime. The repository's working example is the best starting point for the exact installed Zig and compiler revision.

### Build the reference integration

```sh
zig build
zig build zx-example
```

The example compiles ZX and executes its generated Zig. Read the [example directory](https://github.com/MatrixAges/zxc/tree/master/packages/compiler/examples) alongside the repository's build configuration when adapting it.

### Wire the generated module

1. Compile the entry `.zx` file and its imports.
2. Add the generated Zig module to the host build.
3. Make the compiler's `zx_runtime` module available to that module.
4. Create an arena with a lifetime covering execution and result consumption.
5. Decode external input into the generated `Input` shape.
6. Invoke the generated `execute` entry point and handle its result or failure.

Pure generated modules use an arena and input. Modules compiled with state capabilities also receive an execution context. These signatures belong to generated output; inspect that output for the precise types of your revision.

### Keep the result alive

Lists and strings may rely on the execution arena. Consume, serialize, or explicitly copy the result before releasing that memory. Do not retain references after the arena is destroyed.

### Register host capabilities

Use the compiler's context-aware API for Store handles and external imports. Registrations are part of the program's permission boundary. The host is responsible for supplying compatible implementations at execution time.

For stateful logic, define version checks and atomic commit behavior before exposing the function to concurrent requests. For external functions, define failure and ownership behavior at the same boundary.

### Verify the complete path

Compilation proves that the source passed the compiler's checks. Building generated Zig proves compatibility with that host build. Executing representative inputs validates behavior for those inputs. None of these steps alone proves an RX workflow has an execution runtime.

Continue with [validation and delivery](/docs/validate-and-deliver).
