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
