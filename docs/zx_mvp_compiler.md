# ZX MVP compiler 实施方案

## 目标

实现一条不依赖 Node.js 或第三方包的 MVP 编译链：

```text
single .zx source
  -> Zig tokenizer
  -> Zig recursive-descent parser
  -> Zig contract validation
  -> Zig code generator
  -> generated Zig module
  -> Zig integration tests
```

首版验证纯计算核心，不伪造尚未落地的 Runtime。Store setter、`app:db`、跨文件 import 和集合高阶操作由 parser 给出明确的“不在 MVP 范围”诊断，后续在现有 AST 上扩展。

## 支持范围

- `export type`：标量、字符串、对象、枚举引用、可选值、只读列表；
- `export enum`；
- 固定 `Input`、`Output` 和匿名 `export default function`；
- `const`、`if / else`、`switch / case / default`、`return`；
- 数值、布尔、字符串、`null`、对象和列表字面量；
- 字段访问、索引、算术、比较、逻辑和三元表达式；
- 在 ZX 阶段检查声明、对象字段、枚举重复项、返回覆盖和不支持语法；
- 为运行时分支中的局部数值常量生成明确 Zig 类型，并由 Zig 完成最终表达式类型检查；
- 生成可直接由 Zig 编译的 `Input`、`Output`、enum 和 `execute`。

## 文件结构

```text
build.zig                    # 构建、运行与端到端测试图
build.zig.zon                # Zig package 元数据
src/
  main.zig                   # CLI 与文件 I/O
  compiler.zig               # 编译 API 和阶段编排
  compiler/
    ast.zig                  # AST 和 source location
    diagnostic.zig           # 结构化诊断
    tokenizer.zig            # lexer
    parser.zig               # recursive-descent parser
    validate.zig             # contract validation
    generator.zig            # Zig code generator
tests/
  fixtures/order_quote.zx    # 中小规模生产型函数
  order_quote_test.zig       # 3 个 ZX -> Zig -> execute 测试
```

公开 API：

```zig
pub fn compile(
    allocator: std.mem.Allocator,
    source: []const u8,
    file_name: []const u8,
) std.mem.Allocator.Error!Result;
```

`Result` 是 `zig_source | diagnostic` 联合：语法和契约错误作为带源码位置的值返回，只有内存分配失败进入 Zig error set。

CLI：

```bash
zig build
./zig-out/bin/zxc tests/fixtures/order_quote.zx --out /tmp/order_quote.zig
zig build test
```

## 端到端验收

生产型 fixture 采用订单报价决策函数，包含：

- 空订单、库存、风控和内部渠道授权校验；
- 客户等级与批量折扣；
- 折扣上限；
- 国内/国际运费与免邮策略；
- 枚举状态与可选失败原因。

三个测试分别验证：

1. 空订单被拒绝；
2. 内部渠道缺少审批时被拒绝，并覆盖 `switch`；
3. Gold 客户的大额订单正确计算折扣、免邮和最终金额。

`build.zig` 中的测试图先运行本次构建出的 `zxc`，把 fixture 编译到 `.zxc/tests/fixtures/`，再把该生成文件作为 `subject` module 交给 Zig test。测试不依赖手工维护的生成代码快照。

关键 codegen 映射为：

```zig
// ZX: a && b, a || b, optional ?? fallback
(a and b)
(a or b)
(optional orelse fallback)

// ZX: condition ? left : right
(if (condition) left else right)
```

可选对象字段生成 `?T = null`，对象字面量生成 Zig 匿名 struct literal，默认函数固定生成 `pub fn execute(in: Input) Output`。运行时分支产生的数字常量会由 codegen 标注为具体 Zig 数值类型，避免 `comptime_int` 依赖运行时控制流；生成模块随后仍由 Zig 做最终类型检查。

## 明确不做

- 不读取或 import `.rx`；
- 不实现 Store Runtime、数据库连接池或 `app:db`；
- 不实现跨 `.zx` 模块解析；
- 不实现 `map / filter / reduce`、模板字符串和对象 spread；
- 不把不支持的语法静默转成含义不同的 Zig。

这些边界必须以包含源码行列的编译错误呈现，不能退化为无提示跳过。
