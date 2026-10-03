CLI 将 ZX 编译为 Zig，也用于格式化 ZX 源码。从仓库构建后得到 `zig-out/bin/zxc`；若已将该二进制放入 `PATH`，也可以直接使用 `zxc`。

### 编译

```sh
zig-out/bin/zxc packages/compiler/examples/quote.zx --out /tmp/quote.zig
```

| 参数           | 含义                    |
| -------------- | ----------------------- |
| 输入路径       | 入口 `.zx` 文件         |
| `--out <path>` | 生成的 Zig 源码目标路径 |
| `--help`       | 输出 CLI 用法           |

编译包含导入分析与编译器语义检查。输出是 Zig 源码，不是可执行文件、Web 服务器或部署包。将其构建进宿主时，需要解析生成代码中的 `zx_runtime` 导入。

### 格式化

```sh
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --check
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --write
```

| 模式      | 效果                                        |
| --------- | ------------------------------------------- |
| 无标记    | 将格式化后的源码输出到标准输出              |
| `--check` | 比较源码与格式化结果；状态码 1 表示存在差异 |
| `--write` | 用格式化结果覆盖源文件                      |

在已有验证流程中使用检查模式，只有确实要修改源码时才使用写入模式。

### 路径与环境

相对导入以导入方文件为起点，`@/` 导入以 CLI 工作目录为起点。应从明确的项目根目录运行命令，让同一个导入在本地和自动化环境中含义一致。

### 不存在的命令

此 CLI 没有通用的 `zxc run`、`zxc check`、`zxc watch` 或 `zxc server`，也没有执行 RX XML 的命令。`zig build zx-example` 是仓库构建步骤，不是 zxc 子命令。

继续阅读[诊断信息](/docs/troubleshooting)或 [Zig 宿主集成](/docs/host-integration)。
