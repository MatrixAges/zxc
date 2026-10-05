### RX 词汇

| 结构                        | 职责                   |
| --------------------------- | ---------------------- |
| `Module`                    | 普通工作流文件的根节点 |
| `Call`                      | 调用 RX 服务或 ZX 函数 |
| `Task`                      | 为一组相关步骤命名     |
| `Parallel`                  | 组合独立任务或调用     |
| `Switch`、`Case`、`Default` | 选择分支               |
| `Return`                    | 返回工作流结果         |
| `Emit`                      | 描述向外发出的业务事件 |
| `Import`                    | 显式声明可选的组合依赖 |

`Task` 不能直接包含另一个 `Task`。`Case` 和 `Default` 必须位于 `Switch` 内。

### 文件角色

| 文件           | 用途                    |
| -------------- | ----------------------- |
| `*.rx`         | 普通模块编排            |
| `*.zx`         | 带类型的业务计算        |
| `*.gateway.rx` | Gateway、分组和路由声明 |
| `*.store.rx`   | Store、对象和字段声明   |

Gateway 和 Store 的名称描述业务边界，不能替代普通模块的文件路径身份。Store 别名标识数据命名空间，不是模块别名。

### 属性契约

| 标签           | 必填属性                           | 可选属性 / 限制                  |
| -------------- | ---------------------------------- | -------------------------------- |
| `Module`       | 无                                 | 无名称；普通 `.rx` 根节点        |
| `Call`         | `in`，以及 `fn` / `service` 二选一 | `out`；`setter` 仅适用于 `fn`    |
| `Import`       | `from`                             | 无别名；仅声明依赖               |
| `Task`         | `name`                             | 非空；不能直接嵌套 `Task`        |
| `Parallel`     | 无                                 | 非空；子节点仅限 `Task` / `Call` |
| `Switch`       | `on`                               | 子节点为 `Case` / `Default`      |
| `Case`         | `value`                            | 同一 switch 中唯一；主体非空     |
| `Default`      | 无                                 | 每个 switch 最多一个；主体非空   |
| `Return`       | `value`                            | 叶节点                           |
| `Emit`         | `event`、`value`                   | 叶节点                           |
| 模块级 `Store` | `from`                             | 可选 `as` 命名空间               |

属性是当前结构模型校验的一部分。`$in`、`$ctx.result` 等表达式字符串需要由宿主解释；RX 包目前不会解析它们，也不会与 ZX 进行类型关联检查。

### 校验范围

该包校验已经构造的 AST、注册普通模块路径，并检查图中的边是否形成环。它不提供 XML 加载、自动返回推断、ZX 链接、事件订阅或运行时执行。

示例见[分支与任务](/docs/control-flow)。Gateway 和 Store 根节点另有[声明参考](/docs/gateway-and-store)。

### 编译器命令

```sh
zxc input.zx --out output.zig
zxc fmt input.zx --check
```

如果 `zxc` 不在 `PATH` 中，请使用本地构建的二进制路径。CLI 的 `@/` 导入相对于当前工作目录，普通相对导入则相对于导入方文件。
