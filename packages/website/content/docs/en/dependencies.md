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
