### Why XML

RX expresses how business units compose and how data crosses their boundaries. XML tags distinguish node responsibilities, nesting shows structural hierarchy, and attributes identify call targets and inputs and outputs. For example, `Call` expresses a call, `service` identifies its target, and `in` and `out` describe data connections. These relationships are visible before reading the computation.

Explicit opening and closing tags make boundaries independent of indentation. People and AI can read, generate, and change subtrees, while tools check allowed tags, attributes, and nesting. The same structural rules at each level provide a consistent language for composition and fractal growth.

XML adds markup. The reason to choose it is explicit structure, not fewer tokens in the syntax itself. Reduced context burden comes from clear boundaries and locating relevant units through dependencies. Nesting expresses containment; calls and imports form the dependency graph. Acyclicity comes from zxc validation rules. Keep computation in ZX rather than accumulating business algorithms inside attributes.

### A module is a file

Use a `Module` root in each ordinary RX file. Do not add a module `name` or wrap it in `Pipeline`. Name and group files by their business responsibility.

```text
checkout.rx
users/load.rx
orders/create.rx
```

### Connect inputs and outputs

In `checkout.rx`:

```xml
<Module>
  <Call service="users/load" in="$in.user_id" out="ctx.user" />

  <Call
    service="orders/create"
    in="{user:ctx.user,items:$in.items}"
    out="ctx.order"
  />

  <Return value="ctx.order" />
</Module>
```

The called files must exist in the application. `service` resolves relative to the calling file; the `.rx` suffix is usually omitted. `$in` is the current module input. `out` names the result used by later steps.

### Call computation

Use `Call.fn` for a function supplied by the application. `fn` and `service` are mutually exclusive. A direct `Call` does not require a duplicate `Import`.

Parallel steps must not depend on each other's unfinished results. A child must not call back into its parent to obtain data; the parent supplies that data as input.

These examples describe the RX composition contract. They require an appropriate host to execute.

### Compose each level with the same boundaries

RX expresses business structure; ZX carries atomic logic. An RX module can call lower-level business modules. When more detail is needed, split those modules by responsibility again. Keep explicit inputs and outputs and one-way dependencies at every level, so readers can understand the current business relationships before looking inside.

Choose boundaries by independent responsibility, reasons to change, and data contracts, rather than line counts. Pass shared data through stable inputs and outputs instead of making modules depend on each other’s internal state. Fractal organization supports further growth, but an acyclic graph can still be tightly coupled. Review the boundaries themselves.
