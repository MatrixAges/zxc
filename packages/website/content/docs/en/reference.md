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

### Compiler commands

```sh
zxc input.zx --out output.zig
zxc fmt input.zx --check
```

Use the path to the locally built `zxc` binary if it is not on `PATH`. The CLI resolves `@/` imports from its current working directory. Ordinary relative imports resolve against their importing file.
