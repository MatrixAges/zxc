zxc uses **RX to express business structure** and **ZX to write atomic logic**. Its core purpose is to make data flow and data architecture visible, keeping a growing business understandable, traceable, and maintainable.

zxc gives business structure to RX and atomic logic to ZX. Boundaries and connections make it explicit where data comes from, which computations it passes through, and where it goes. Compiler dependency checks keep structural constraints in place as the business grows.

### Fractal growth

A ZX unit handles one computation with a clear boundary. RX composes units into business modules, and modules into larger business boundaries. When more detail is needed, split the internals again. Each level keeps a single responsibility, explicit inputs and outputs, and one-way dependencies: the fractal organization of zxc.

An “atom” is a unit with a clear responsibility and contract, not an atomic database transaction or the smallest possible fragment. “Fractal” means applying the same decomposition and composition rules at different levels, not cyclic dependencies or recursive calls. Explicit connections show which units data passes through; input and output types describe its shape at boundaries. Acyclicity constrains dependency direction but cannot eliminate all business coupling.

### AI context

Built-in dependency analysis makes file, call, and type relationships checkable facts. We want to expose this graph directly to AI: locate relevant units, trace upstream and downstream relationships, assess change impact, and retrieve context on demand, with a trail for every change.

The goal is to minimize token use and cognitive load, helping non-SOTA models meet the same code quality standards as SOTA models through explicit contracts and compiler feedback.

### Atomic optimization

A ZX unit with a clear boundary can be analyzed and optimized like a computational operator. Static information in zxc and compile-time capabilities in Zig create paths for inlining, specialization, and eliminating abstraction overhead, bringing clear business expression and high performance closer together.

ZX currently compiles to Zig. When using Zig’s LLVM backend, the program can benefit from target-specific optimization and machine-code generation. Zero-cost abstraction is a goal to verify through generated code and measurement, not a claim that every operation has no allocation or runtime cost.

The longer-term direction includes formal specifications and proofs for atomic units, assembly-level analysis and generation, and hardware targets such as FPGA. Formal verification needs dedicated proof tools; FPGA needs synthesis flows and backends. These are future directions, not capabilities automatically supplied by LLVM or already delivered by zxc.

### Capabilities

See [capabilities and limits](/docs/capabilities) for current implementation and runnable paths. Design goals are not already shipped tool interfaces or measured performance results.

### Follow one path to a working result

1. [Choose an integration](/docs/choose-integration) based on whether you need computation, composition, or host capabilities.
2. [Build the compiler](/docs/getting-started) and execute the existing ZX example.
3. [Write typed logic](/docs/write-logic) with an explicit input and output.
4. [Compose modules](/docs/compose-modules) when the application needs a visible workflow boundary.
5. [Validate the delivery](/docs/validate-and-deliver) against the capabilities of the actual host.

### Shared concepts

| Concept         | Meaning                                                               |
| --------------- | --------------------------------------------------------------------- |
| Module identity | A normalized file path, not an arbitrary module name                  |
| Input / output  | The values crossing a computation boundary                            |
| Dependency      | A static relationship created by an import or service call            |
| Capability      | A host-provided operation or state handle made available explicitly   |
| Ownership       | Which binding may consume or retain a value                           |
| Host            | The program responsible for execution, memory, I/O, and state commits |

### Read by task, look up by contract

The guides explain how to build a small working unit and extend it. The references summarize tags, language constructs, and CLI arguments. Read the limitations alongside a feature before promising that feature in an application.

For machine-readable access, use [the documentation index](/llms.txt), [the full text](/llms-full.txt), or the `.md` link on a chapter. All are derived from the same chapter sources.
