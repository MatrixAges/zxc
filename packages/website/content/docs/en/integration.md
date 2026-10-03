Choose the smallest boundary that can deliver your application. A ZX computation, an RX composition, and a host runtime solve different problems.

### Select a starting point

| Your task                                   | Start with               | What you need                                     |
| ------------------------------------------- | ------------------------ | ------------------------------------------------- |
| Validate and compile a business calculation | A `.zx` file             | The compiler and explicit input/output types      |
| Execute compiled logic                      | Generated Zig            | `zx_runtime`, an arena, and a Zig host            |
| Describe a multi-step workflow              | An ordinary `.rx` module | An execution host beyond the current RX validator |
| Declare routes or shared state              | Gateway or Store files   | Host implementations for transport and state      |
| Generate an application with an agent       | The agent guide          | Your toolchain, runtime, and acceptance criteria  |

### Start with computation

If you need a working first example, build and execute the repository's ZX example. This exercises the compiler and its Zig integration together. Follow [getting started](/docs/getting-started), then replace the example calculation with your own typed input and output.

### Add composition at a real boundary

Use RX to express which units call which other units. Keep arithmetic and transformations in ZX. A workflow declaration is useful for reviewing structure even before an execution host exists, but it is not an executable service by itself.

### Establish the host contract

Before adding network or state behavior, identify who supplies transport, authentication, input decoding, memory lifetime, state access, and commit semantics. The current compiler does not supply a server or database.

Continue with [Zig host integration](/docs/host-integration) for executable ZX, or [compose modules](/docs/compose-modules) for RX structure.
