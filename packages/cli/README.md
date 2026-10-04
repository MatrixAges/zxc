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

RX 支持独立 verify 与 fpga 命令，使用与 ZX 相同的证明和硬件后端；详见 [RX 证明与硬件 reference](../../docs/2026-10-05/RX证明与硬件参考.md)。RX fmt 尚未接入。当前 lib 仍采用单 ZX 文件闭包发布模型，尚未实现以模块公共接口为边界的统一库机制；不能将其缺口理解为增加一种源码入口，见 [统一库设计](../../docs/2026-10-05/统一库设计.md)。Store 声明、Call.in 读取视图与单 Object setter 支持源码生成及原生 app；应用启动时初始化共享内存，进程结束后释放，不自动落盘。Parallel、事件和 Gateway 执行仍未接入。语法和公开库接口见 [RX reference](../compiler/src/rx/README.md)。

`zxc verify path/to/pkg.yaml --solver /path/to/z3 --out build/proof` 加载源码清单的全部 `exports`，统一联结后逐个验证公开可调用模块；纯类型模块仅报告接口校验通过。清单必须声明 exports。`--out` 在此作为文件名前缀，每个模块使用 `前缀.公开名称摘要.smt2` 及配套证据文件，避免多个导出相互覆盖；省略时沿用默认证明缓存路径。任一公开入口存在反例、不支持的证明语义或求解失败，命令退出非零。该命令沿用现有证明范围，不证明任意业务意图，也不表示包级库发布已经完成。

已编译库的清单使用 `library: library.zxcir` 指定包内产物，exports 使用模块选择：

```yaml
name: workflow
version: 1.0.0
library: library.zxcir
exports:
    ./choose:
        module: choose
    ./read:
        module: read
```

消费方在 dependencies 中声明 workflow，再使用 `import choose from "workflow/choose"`。`zxc build main.zx --out app` 自动按依赖作用域读取和校验产物，同一实例只解码一次；库不需要携带原 RX/ZX 实现源码。类型导入仍限于产物明确公开的类型。无效、不兼容或缺少指定公开模块的产物直接报错，不回退到源码。

源码包仍使用 exports 的字符串实现路径；两种目标不能混用，library 必须搭配 exports 且不能使用 entry。当前已编译输入跳过语义产物缓存，`--cache-stats` 会说明这一点；解析及代码生成缓存仍可使用。完整多模块发布、非标准原生资源重绑定、Store 初始化、编译包再次发布及直接 verify 编译包仍待接通，不能以纯计算消费成功推断这些能力已完成。

## 包的公开模块

pkg.yaml 可以通过 exports 显式列出公开模块：

```yaml
name: arithmetic
version: 1.0.0
exports:
    ./increment: increment.zx
    ./multiply: multiply.zx
```

已声明该包依赖的消费者可导入 `arithmetic/increment` 与 `arithmetic/multiply`；包内部可以使用相同公开名称自引用。`.` 表示默认公开模块，没有声明时不自动提供。公开路径不能包含空段、上级目录或通配符；实现路径必须位于包内，消费时继续进行物理路径检查。

entry 与 exports 不能同时声明。当前已接通映射解析和项目消费；带 exports 的包尚不能走旧单文件 lib 发布流程，会明确报错。统一模块编译及发布仍按 [统一库设计](../../docs/2026-10-05/统一库设计.md)继续实现。
