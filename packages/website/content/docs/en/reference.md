### RX vocabulary

| Construct                   | Responsibility                             |
| --------------------------- | ------------------------------------------ |
| `Module`                    | Root of an ordinary workflow file          |
| `Call`                      | Invoke an RX service or ZX function        |
| `Task`                      | Name a related group of steps              |
| `Parallel`                  | Compose independent tasks or calls         |
| `Switch`, `Case`, `Default` | Select a branch                            |
| `Return`                    | Return the workflow result                 |
| `Emit`                      | Describe an outgoing business event        |
| `Import`                    | Declare an optional composition dependency |

`Task` does not directly contain another `Task`. `Case` and `Default` belong inside `Switch`.

### File roles

| File           | Purpose                                |
| -------------- | -------------------------------------- |
| `*.rx`         | Ordinary module orchestration          |
| `*.zx`         | Typed business computation             |
| `*.gateway.rx` | Gateway, group, and route declarations |
| `*.store.rx`   | Store, object, and field declarations  |

Gateway and Store names describe their business boundary. They do not replace the file-path identity of ordinary modules. A Store alias identifies a data namespace, not a module alias.

### Attribute contracts

| Tag                  | Required attributes                   | Optional attributes / restrictions      |
| -------------------- | ------------------------------------- | --------------------------------------- |
| `Module`             | None                                  | No name; ordinary `.rx` root            |
| `Call`               | `in`, exactly one of `fn` / `service` | `out`; `setter` only with `fn`          |
| `Import`             | `from`                                | No alias; dependency only               |
| `Task`               | `name`                                | Nonempty; no direct nested `Task`       |
| `Parallel`           | None                                  | Nonempty; only `Task` / `Call` children |
| `Switch`             | `on`                                  | `Case` / `Default` children             |
| `Case`               | `value`                               | Unique within its switch; nonempty body |
| `Default`            | None                                  | At most one per switch; nonempty body   |
| `Return`             | `value`                               | Leaf                                    |
| `Emit`               | `event`, `value`                      | Leaf                                    |
| Module-level `Store` | `from`                                | Optional `as` namespace                 |

Attributes are validated as part of the current structural model. Expression strings such as `$in` and `ctx.result` require host interpretation; the RX package does not currently parse or type-check them against ZX.

### Validation scope

The package validates an already constructed AST, registers ordinary module paths, and checks graph edges for cycles. It does not supply XML loading, automatic return inference, ZX linkage, event subscriptions, or runtime execution.

For examples see [branches and tasks](/docs/control-flow). Gateway and Store roots have their own [declaration reference](/docs/gateway-and-store).

### Compiler commands

```sh
zxc input.zx --out output.zig
zxc fmt input.zx --check
```

Use the path to the locally built `zxc` binary if it is not on `PATH`. The CLI resolves `@/` imports from its current working directory. Ordinary relative imports resolve against their importing file.
