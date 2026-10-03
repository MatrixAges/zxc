State is an explicit compiler and host boundary. A Store declaration describes data; a running host must implement how that data is read, changed, and committed.

### Separate the three layers

| Layer                  | Responsibility                                                         |
| ---------------------- | ---------------------------------------------------------------------- |
| RX Store declarations  | Describe objects and fields                                            |
| ZX compilation context | Register handles and allowed access                                    |
| Execution host         | Supply values, lifetime, concurrency, persistence, and commit behavior |

The current repository does not automatically link an RX Store file into a ZX execution context. Do not assume a matching name creates a usable capability.

### Supply capabilities deliberately

Host integration registers Store capabilities through `compileWithContext` or the project compilation context. Read and write permissions are independent. The generated stateful entry point receives the host context in addition to its arena and input.

The command-line compiler cannot infer application-specific handles from a Store XML file. Use the compiler integration API when compilation requires those handles.

### Define commit semantics before writing state

For each operation, decide which values form one consistent snapshot, which version is checked, and what happens when a competing update wins. The host owns locking, versions, persistence, and atomic publication across objects.

A compiler check is not a transaction manager. If an operation updates two objects, a host that writes them independently can still expose partial state.

### Keep pure work separate

Prefer typed input and output for calculations that do not need state. Pass the necessary snapshot into a pure ZX function, then let the host apply the result under its commit policy. Introduce Store access only where direct capability access is required.

Read [Gateway and Store declarations](/docs/gateway-and-store) for the structural vocabulary and [capabilities](/docs/capabilities) for implementation limits.
