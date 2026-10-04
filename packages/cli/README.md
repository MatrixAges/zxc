# cli

## Intent：最终目标

提供唯一的 zxc 可执行文件，集中处理命令与系统交互。

## Data：实现范围

命令分发、项目装载、包管理命令、缓存落盘、watch、外部工具调用及发行资源装配。既有运行回归在 tests/runtime，示例在 examples。

## Edges：职责边界

编译语义通过 compiler 包完成。标准库源码属于 compiler/standard；CLI 将其作为发行资源嵌入，不另存一份实现。compiler 不依赖 CLI。

## Answer：构建与验证

```sh
zig build
zig build test
```

仓库根目录使用 `zig build dist` 生成可分发程序与许可证。离线归档选项为 `-Dzig-archive=/absolute/path/to/archive`。成功标准包括既有运行回归，以及在空 PATH 下使用内嵌工具链完成真实构建。

## RX 应用构建

普通 RX 模块中的 Call.fn、Call.service、Return、Task 与 Switch 可以直接构建应用：

```sh
zxc build workflow.rx --out build/workflow

./build/workflow '{"value": 41}'
```

输入 JSON 必须符合从 Call.in 与函数 Input 推导出的模块类型；未使用输入的模块不接收命令行参数。程序将返回值写为 JSON，void 输出写为 null。

| 用法                                          | 行为                                                       |
| --------------------------------------------- | ---------------------------------------------------------- |
| `zxc workflow.rx --out workflow.zig`          | 输出 Zig 源码；原生模块所需类型另写入 workflow.zig.abi.zig |
| `zxc build workflow.rx --out build/workflow`  | 使用内嵌工具链构建可执行应用                               |
| `--project pkg.yaml`                          | 使用既有包解析及原生模块配置                               |
| `--cache-stats` / `--no-cache`                | 报告或关闭 Zig 代码生成缓存；RX 语义推导当前重新执行       |
| `--watch`                                     | 观察 RX、ZX 依赖、配置及后端依赖，变化后重新构建并安全发布 |
| `--asm` / `--target` / `--cpu` / `--optimize` | 沿用既有应用构建选项                                       |
| `--solver`                                    | 使用指定证明求解器；包含形式化契约时构建仍必须通过证明     |

service 相对当前模块文件解析；同一个服务文件在所有调用处共享一个输入输出契约。入口递归装载 Import 和 service，先检查完整依赖图无环，再共同推导类型并生成代码。Import 不触发执行。

RX 与直接函数路径受项目根边界约束。已声明依赖包沿既有 package scope 解析；无包配置时导入闭包也检查物理路径。构建不会启动生成的业务程序。

当前 RX 入口不支持 fmt、独立 verify、fpga 或 lib 发布命令，遇到这些模式会明确报错。Store 声明、Call.in 快照与单 Object setter 支持生成接受显式宿主的 Zig 源码；含 Store 定义的原生 app 尚未接入状态生命周期。Parallel、事件和 Gateway 执行仍未接入。语法和公开库接口见 [RX reference](../compiler/src/rx/README.md)。
