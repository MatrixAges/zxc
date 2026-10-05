RX groups and selects work; ZX performs typed computation inside that work. The RX examples here describe structure accepted by the tag model. An execution host must supply scheduling and expression evaluation.

### Group a sequence

```xml
<Module>
  <Task name="prepare" out={$ctx.quote}>
    <Call module="users/load" in={$in.user_id} />
    <Call fn="quote" in={$in} />
  </Task>

  <Return value={$ctx.task.prepare} />
</Module>
```

`Task.name` must be nonempty. A `Task` cannot directly contain another `Task`. Use the group for a coherent responsibility; extract a service when a group becomes a reusable boundary.

### Describe independent work

```xml
<Parallel>
  <Task name="user" out={$ctx.load}>
    <Call module="users/load" in={$in.user_id} />
  </Task>

  <Task name="item" out={$ctx.load}>
    <Call module="catalog/load" in={$in.item_id} />
  </Task>
</Parallel>
```

`Parallel` has no attributes and accepts only `Task` or `Call` children. It must contain at least one child. Do not make one parallel branch consume an unfinished result from another. The structural validator does not establish runtime race freedom.

### Select a branch

```xml
<Switch on={$in.kind}>
  <Case value={priority}>
    <Call module="orders/priority" in={$in} />
  </Case>

  <Default>
    <Call module="orders/standard" in={$in} />
  </Default>
</Switch>
```

`Switch.on` and `Case.value` are required. Cases must have unique values; at most one `Default` is allowed. `Case` and `Default` bodies must be nonempty. Put the default last for readability, though the validator does not require that order.

### Return and emit explicitly

`Return` requires a `value`. `Emit` requires `event` and `value`. Both are leaves. An event declaration does not create a subscriber, delivery guarantee, or background worker.

For computation-level branching, use ZX `if`, early `return`, and conditional expressions. See [ZX reference](/docs/zx-reference).
