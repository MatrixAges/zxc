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

RX 支持独立 verify 与 fpga 命令，使用与 ZX 相同的证明和硬件后端；详见 [RX 证明与硬件 reference](../../docs/2026-10-05/RX证明与硬件参考.md)。RX fmt 尚未接入。源码包现在支持统一 lib 发布，可在同一公开集合中包含 RX 与 ZX 模块；单 entry 或直接文件构建归一为默认公开模块，见 [统一库设计](../../docs/2026-10-05/统一库设计.md)。Store 声明、Call.in 读取视图与单 Object setter 支持源码生成及原生 app；应用启动时初始化共享内存，进程结束后释放，不自动落盘。Parallel、事件和 Gateway 执行仍未接入。语法和公开库接口见 [RX reference](../compiler/src/rx/README.md)。

`zxc verify path/to/pkg.yaml --solver /path/to/z3 --out build/proof` 加载源码清单的全部 `exports`，统一联结后逐个验证公开可调用模块；纯类型模块仅报告接口校验通过。清单必须声明 exports。`--out` 在此作为文件名前缀，每个模块使用 `前缀.公开名称摘要.smt2` 及配套证据文件，避免多个导出相互覆盖；省略时沿用默认证明缓存路径。任一公开入口存在反例、不支持的证明语义或求解失败，命令退出非零。该命令沿用现有证明范围，不证明任意业务意图，包级发布使用下面的 build 命令。

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

消费方在 dependencies 中声明 workflow，再使用 `import choose from "workflow/choose"`。`zxc build main.zx --out app` 自动按依赖作用域读取和校验产物，分析阶段同一实例只解码一次；含原生配置的包还会在配置阶段读取产物绑定身份；库不需要携带原 RX/ZX 实现源码。类型导入仍限于产物明确公开的类型。无效、不兼容或缺少指定公开模块的产物直接报错，不回退到源码。

源码包仍使用 exports 的字符串实现路径；两种目标不能混用，library 必须搭配 exports 且不能使用 entry。当前已编译输入跳过语义产物缓存，`--cache-stats` 会说明这一点；解析及代码生成缓存仍可使用。源码 exports 包已支持多模块发布、原生资源重绑定，以及导入编译包后再次发布。直接对已编译清单执行 build --mode lib 或 verify 尚未接通；Store 状态的完整发布消费仍需单独验证。

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

entry 与 exports 不能同时声明。entry 支持包内 .zx 或 .rx 路径，构建时归一为默认公开模块。发布全部公开模块：

```sh
zxc build pkg.yaml --mode lib --out dist/arithmetic
```

输出包含 library.zxcir、pkg.yaml、build.zig、公共与内部 Zig 模块、共享 ABI 及原生资源。消费方不需要原 RX/ZX 实现源码。使用 Zig 的路径依赖时，通过 `dependency.module("./increment")` 获取公开模块；名称完整保留 exports 键，默认公开模块使用 `dependency.module(".")`。单 entry 或直接文件构建保留既有 Zig `library` 模块名与 `root.zig` 文件，zxc 则通过默认包导入消费；不再发布 source/module_0.zx。调用 execute 时沿用生成签名，例如 `try increment.execute(&arena, value)`。

构建先验证所有公开模块的契约，再从暂存目录发布；`--watch` 沿用输入变化检查，`--cache-stats` 可观察模块级 Zig 生成复用。原生路径与 ABI 别名随包搬迁，外部系统库和外部头文件搜索路径仍是显式构建要求。

详见 [统一库发布 reference](../../docs/2026-10-05/统一库发布参考.md)；完整设计与剩余边界见 [统一库设计](../../docs/2026-10-05/统一库设计.md)。

## WebAssembly

`zxc build main.zx --target wasm32-wasi --out main.wasm` 生成 WASI preview1 命令应用；`--target wasm32-freestanding` 生成可由标准 WebAssembly 宿主实例化的调用模块。ZX 与普通 RX 共用生成管线，RX Store 在实例内跨调用保留。freestanding 提供 JSON 输入输出及标量直接调用，显式管理请求与状态生命周期，不提供 OS I/O、进程或 Gateway。构建命令、导出 ABI、错误与内存边界见 [WASM reference](../../docs/2026-10-05/WASM参考.md)。

## Node 原生插件

`zxc build main.zx --host node --out addon.node` 生成 Node-API 6 插件及 `addon.cjs`、`addon.d.cts`。Node 使用 `require("./addon.cjs").execute(input)`，ESM/TypeScript 使用 `import { execute } from "./addon.cjs"`；声明自动导出 Input、Output 和 execute，支持 NodeNext 类型检查。插件直接转换 JavaScript 值，不通过 JSON 中转；64 位整数使用 BigInt，void 输出为 undefined，RX Store 按插件函数实例保留。Windows 构建通过 --node-lib 指定对应架构的 Node 导入库。类型、生命周期与当前能力边界见 [N-API reference](../../docs/2026-10-05/NAPI参考.md)。
