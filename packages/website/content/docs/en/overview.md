zxc is a programming language and compiler designed for agents. It separates application structure from computation:

- **RX** (`.rx`): XML that describes orchestration and explicit module boundaries.
- **ZX** (`.zx`): a constrained, TypeScript-like language for statically checked business logic.

A module has one responsibility. A file path is its identity. Data crosses boundaries through explicit inputs and outputs. Dependency cycles are rejected.

Start with [capabilities and limits](/docs/capabilities). A language design is not a promise that every feature has a runtime implementation.

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
