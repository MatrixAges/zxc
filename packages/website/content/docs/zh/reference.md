### RX 词汇

| 结构                        | 职责                   |
| --------------------------- | ---------------------- |
| `Module`                    | 普通流程文件的根       |
| `Call`                      | 调用 RX 服务或 ZX 函数 |
| `Task`                      | 为一组相关步骤命名     |
| `Parallel`                  | 组合独立任务或调用     |
| `Switch`、`Case`、`Default` | 选择分支               |
| `Return`                    | 返回流程结果           |
| `Emit`                      | 描述对外业务事件       |
| `Import`                    | 声明可选的模块组合依赖 |

`Task` 不能直接包含另一个 `Task`。`Case` 和 `Default` 只能放在 `Switch` 中。

### 文件职责

| 文件           | 用途                         |
| -------------- | ---------------------------- |
| `*.rx`         | 普通模块编排                 |
| `*.zx`         | 有类型的业务计算             |
| `*.gateway.rx` | Gateway、Group 和 Route 声明 |
| `*.store.rx`   | Store、Object 和 Field 声明  |

Gateway 与 Store 的名称描述其业务边界，不能替代普通模块的文件路径身份。Store 别名标识数据命名空间，不是模块别名。

### 编译器命令

```sh
zxc input.zx --out output.zig
zxc fmt input.zx --check
```

若本地构建的 `zxc` 不在 `PATH` 中，请使用其实际路径。CLI 以当前工作目录解析 `@/` 导入，普通相对导入则相对导入方文件解析。
