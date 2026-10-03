### 一个模块就是一个文件

普通 RX 文件以 `Module` 为根。不要添加模块 `name`，也不要包装在 `Pipeline` 中。按业务职责命名和分组文件。

```text
checkout.rx
users/load.rx
orders/create.rx
```

### 连接输入与输出

在 `checkout.rx` 中：

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

被调用的文件必须真实存在于应用中。`service` 相对调用文件解析，通常省略 `.rx` 后缀。`$in` 是当前模块的输入，`out` 命名结果供后续步骤使用。

### 调用计算逻辑

使用 `Call.fn` 调用应用提供的函数。`fn` 与 `service` 必须二选一。直接 `Call` 不需要重复声明 `Import`。

并行步骤不能依赖彼此尚未完成的结果。子模块不能反向调用父模块获取数据；父模块应通过输入提供这些数据。

这些示例描述 RX 组合契约，需要合适的宿主才能执行。
