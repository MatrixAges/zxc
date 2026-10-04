<p align="center">
  <img src="packages/website/public/logo.svg" alt="zxc" width="160" />
</p>

<h1 align="center">zxc</h1>

<p align="center">
  <strong>面向 AI 协作的业务编程语言：结构可见，逻辑独立。</strong>
</p>

<p align="center">
  用 <b>RX</b> 描述业务结构，用 <b>ZX</b> 编写原子逻辑，编译为原生程序。
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License" /></a>
  <img src="https://img.shields.io/badge/status-experimental-orange.svg" alt="Experimental" />
  <img src="https://img.shields.io/badge/zig-0.16.0-f7a41d.svg" alt="Zig 0.16.0" />
</p>

<p align="center">
  <a href="#快速开始">快速开始</a> ·
  <a href="#一个完整的例子">示例</a> ·
  <a href="#项目状态">项目状态</a> ·
  <a href="packages/skills/README.md">应用开发指南</a> ·
  <a href="packages/compiler/src/rx/README.md">RX 参考</a>
</p>

---

## zxc 是什么

zxc 是一门编程语言及其编译器，由两部分组成：

| 语言   | 形式          | 负责什么                                        |
| ------ | ------------- | ----------------------------------------------- |
| **ZX** | 类 TypeScript | 一个文件一项计算：声明 `Input`、`Output` 和规则 |
| **RX** | XML           | 业务结构：谁调用谁、数据从哪里来、流向哪里      |

ZX 经过类型与所有权检查后生成 Zig，RX 把这些计算单元组合成模块，模块再组合成更大的业务。`zxc build` 内嵌 Zig 工具链，直接产出可执行程序。

## 为什么需要 zxc

让 AI 编写和维护一个持续增长的业务系统时，困难通常不在于单个函数，而在于结构：

- **结构藏在代码里。** 调用关系、数据流向散落在函数体中，AI 必须读大量代码才能拼出全貌，上下文迅速膨胀。
- **边界靠自觉维持。** 职责划分、依赖方向只是约定，几轮修改后耦合与循环依赖悄悄出现。
- **改动影响难以判断。** 改一处规则，不知道哪些上下游会受影响。

zxc 把这些从"约定"变成"语言规则"：

- **结构即代码** — RX 文件本身就是业务的数据流图，沿着 `Call` 的 `in` / `out` 就能读懂业务。
- **一个单元，一项职责** — 每个 ZX 文件只有一个默认导出函数，输入输出都有类型，边界不会被悄悄打破。
- **无环是硬约束** — 模块依赖图必须无环，编译器检查且不提供关闭选项。
- **分形组合** — 函数组成模块，模块组成更大的模块，每一层沿用同一套规则。

结果是：人和 AI 都能只读少量文件就定位改动，编译器负责守住结构。

## 一个完整的例子

一个订单结算：计算折扣后的应付金额，满额免邮。

**`quote.zx`** — 原子逻辑，只关心计算本身：

```typescript
export type Input = {
  subtotal: u64
  discount: u64
  shipping_fee: u64
  free_shipping_minimum: u64
}

export type Output = {
  shipping: u64
  payable: u64
}

export default function (in: Input): Output {
  const discount = in.discount > in.subtotal ? in.subtotal : in.discount
  const discounted = in.subtotal - discount

  const shipping = match {
    discounted >= in.free_shipping_minimum => 0,
    _ => in.shipping_fee
  }

  return { shipping: shipping, payable: discounted + shipping }
}
```

**`checkout.rx`** — 业务结构，把输入交给报价函数并返回结果：

```xml
<Module>
  <Call fn="quote" in="$in" out="ctx.quote" />

  <Return value="ctx.quote" />
</Module>
```

**`order.rx`** — 分形组合，把整个结算模块当作一个服务调用：

```xml
<Module>
  <Call service="checkout" in="$in" out="ctx.checkout" />

  <Return value="ctx.checkout" />
</Module>
```

构建并运行：

```sh
zxc build order.rx --out build/order

./build/order '{"subtotal":12000,"discount":2000,"shipping_fee":600,"free_shipping_minimum":10000}'
# {"payable":10000,"shipping":0}
```

模块的输入输出类型由编译器从 `Call` 与 ZX 函数签名推导，不需要另写类型文件。免邮规则变化时只需修改 `quote.zx`，`checkout.rx` 与 `order.rx` 保持不变。

## 特性

**ZX 语言**

- 类 TypeScript 语法，只有 `const`，无分号；`if`、`switch`、`match` 表达式、解构与展开
- 显式数值类型（`u64`、`i32`、`f32` …）、对象、枚举、optional、列表与元组
- 所有权检查：无指针语法，无 `clone`，聚合值的传递与存储由编译器决定
- 无捕获的 `map` / `filter` / `reduce`
- 标准库：`std:encoding`、`std:crypto`、`std:path`、`std:querystring`、`std:zlib`、`std:os`
- 通过 `zig:` / `c:` 显式接入并审查原生接口
- `requires` / `ensures` 契约，对有限整数子集做 SMT 验证

**RX 组合**

- `Call`、`Return`、`Task`、`Switch` 可直接构建应用
- 模块身份即文件路径，无全局命名、无隐式查找
- 整个依赖图强制无环

**工具链**

- 单个可执行文件，内嵌官方 Zig 0.16.0，用户无需安装 Zig
- `zxc build` 构建原生程序，支持 `--target`、`--cpu`、`--optimize`、`--asm`
- `--watch` 增量重建，`zxc fmt` 格式化
- 开放 IR 与 `frontend` 模块，可接入第三方后端

## 快速开始

当前通过源码构建，需要 [Zig 0.16.0](https://ziglang.org/download/)：

```sh
git clone https://github.com/MatrixAges/zxc.git
cd zxc
zig build
```

编译器位于 `zig-out/bin/zxc`。运行仓库自带的示例：

```sh
zig build zx-example
```

把[上面的例子](#一个完整的例子)中的三个文件放在同一目录，执行 `zxc build order.rx` 即可得到可执行程序。更多命令与参数见 [CLI 文档](packages/cli/README.md)。

## 项目状态

zxc 处于**实验阶段**，语言与 IR 都可能发生不兼容变更，暂不建议用于生产。

| 能力                                     | 状态      |
| ---------------------------------------- | --------- |
| ZX 解析、类型与所有权检查、Zig 代码生成  | ✅ 可用   |
| RX `Call` / `Return` / `Task` / `Switch` | ✅ 可用   |
| 依赖无环检查、`zxc build`、`--watch`     | ✅ 可用   |
| `requires` / `ensures` 契约验证          | 🧪 部分   |
| Store 状态存储（运行时生命周期）         | 🚧 进行中 |
| `Parallel` 并行执行、事件、Gateway       | 🚧 进行中 |
| 面向 AI 的依赖图谱查询                   | 🔭 规划中 |
| 形式化证明、FPGA 等硬件目标              | 🔭 长期   |

完整的能力与限制见[网站文档](packages/website/content/docs/zh/limits.md)。

## 仓库结构

| 包                              | 说明                                      |
| ------------------------------- | ----------------------------------------- |
| [`compiler`](packages/compiler) | RX / ZX 前端、类型与所有权分析、Zig 后端  |
| [`cli`](packages/cli)           | `zxc` 可执行文件：命令、构建、watch、发行 |
| [`core`](packages/core)         | IR 数据模型                               |
| [`genz`](packages/genz)         | Zig 代码生成                              |
| [`dsl`](packages/dsl)           | 语法定义框架                              |
| [`lint`](packages/lint)         | 命名与格式规则                            |
| [`pkgs`](packages/pkgs)         | 包管理                                    |
| [`skills`](packages/skills)     | 指导 AI 使用 zxc 编写应用                 |
| [`test`](packages/test)         | 验证与回归                                |
| [`website`](packages/website)   | 官方网站与文档                            |

## 文档

- **使用 zxc：** [应用开发指南](packages/skills/README.md) · [CLI](packages/cli/README.md) · [RX 参考](packages/compiler/src/rx/README.md)
- **语言设计：** [设计文档](docs/zxc_deisgn_doc.md) · [设计思考记录](docs/zxc_raw_thinking.md)
- **参与开发：** [开发约定](AGENTS.md) · [编译器](packages/compiler/README.md) · [验证与回归](packages/test/README.md)

## 许可证

[MIT](LICENSE) © 2026 MatrixAges
