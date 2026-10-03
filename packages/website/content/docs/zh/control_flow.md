RX 负责组织与选择工作，ZX 在其中执行带类型的计算。这里的 RX 示例描述标签模型接受的结构，调度和表达式求值仍需执行宿主提供。

### 将一组步骤归为一个任务

```xml
<Module>
  <Task name="prepare">
    <Call service="users/load" in="$in.user_id" out="ctx.user" />
    <Call fn="quote" in="$in" out="ctx.quote" />
  </Task>

  <Return value="ctx.quote" />
</Module>
```

`Task.name` 不能为空，`Task` 不能直接包含另一个 `Task`。分组应围绕一项连贯职责；当它成为可复用边界时，将其提取为服务。

### 描述相互独立的工作

```xml
<Parallel>
  <Call service="users/load" in="$in.user_id" out="ctx.user" />
  <Call service="catalog/load" in="$in.item_id" out="ctx.item" />
</Parallel>
```

`Parallel` 没有属性，只接受 `Task` 或 `Call` 子节点，且至少包含一个子节点。不要让一个并行分支使用另一个分支尚未完成的结果。结构校验通过，并不能证明运行时不存在竞争。

### 选择分支

```xml
<Switch on="$in.kind">
  <Case value="priority">
    <Call service="orders/priority" in="$in" out="ctx.order" />
  </Case>

  <Default>
    <Call service="orders/standard" in="$in" out="ctx.order" />
  </Default>
</Switch>
```

`Switch.on` 和 `Case.value` 必填。各 `Case` 的值必须唯一，最多允许一个 `Default`。`Case` 和 `Default` 的主体均不能为空。为方便阅读，建议把默认分支放在最后，但校验器没有要求这个顺序。

### 显式返回与发出事件

`Return` 必须有 `value`，`Emit` 必须有 `event` 和 `value`，两者都是叶节点。事件声明不会自动创建订阅者、投递保证或后台工作进程。

计算内部的分支使用 ZX `if`、提前 `return` 和条件表达式，参见 [ZX 参考](/docs/zx-reference)。
