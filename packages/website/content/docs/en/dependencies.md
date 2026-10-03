### Direct dependencies downward

A parent orchestrates children. Children do not call the parent. This rule applies to calls inside conditional branches as well as direct calls.

When two modules need each other:

1. Move shared computation into a third module.
2. Move orchestration into a parent that calls both modules.
3. Pass already-known data through explicit inputs.
4. Split responsibilities when the apparent cycle comes from a module doing two jobs.

Calling the same child twice in sequence is valid. A chain that returns to a module already on that chain is a cycle.

### Do not hide a cycle

Renaming paths, duplicating files, or moving a reverse call behind an event does not resolve an architectural dependency. Verify every reachable module, including conditional branches and explicit imports.

Acyclic module dependencies do not prove algorithm termination, event convergence, or correct business results. Verify those properties separately.

### Recognize valid reuse

```text
checkout → users/load
checkout → orders/create → users/load
```

This diamond is valid: both paths reach the same dependency without returning to an ancestor. Repeated calls to `users/load` do not create a cycle by themselves.

```text
checkout → orders/create → checkout
```

This is a cycle. Extract the shared work or move the coordinating decision into `checkout`; do not rename the reverse dependency to hide it.

### Review declarations, not just execution

Unused ZX imports and explicit RX imports still contribute dependencies. The graph is a static contract, so conditional execution cannot excuse a reverse edge. See [paths and imports](/docs/module-paths) for normalization and resolution rules.
