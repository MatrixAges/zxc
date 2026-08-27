# zxc

zxc 是一个为 AI 设计的编译器，也可以表示一门为 AI 设计的编程语言。这个编程语言提供两种类型的代码文件：`.rx` 和 `.zx`。RX 是 XML 配置，负责编排流程和定义流量出入口；ZX 是类 TypeScript 的有限语法，负责承载单一、可静态验证的业务逻辑。

## MVP compiler

当前 MVP 提供一条纯 Zig、零第三方依赖的 `.zx -> Zig` 编译链，编译器、CLI 和测试均使用 Zig 0.17 nightly。

```bash
zig build
./zig-out/bin/zxc src/order/create.zx
```

不传 `--out` 时，`.zxc/` 会镜像 `src/` 内的目录结构：

```text
src/order/create.zx
→ .zxc/order/create.zig
```

需要覆盖默认生成位置时，可以显式传入 `--out output.zig`。完整路径规则见 [ZXC design](docs/zxc_deisgn_doc.md)。

端到端测试会先运行 Zig 编写的编译器，再将生成模块交给 Zig 编译并执行 3 个业务用例：

```bash
zig build test
```

MVP 已支持：

- 标量、字符串、对象、枚举、可选值和只读列表类型；
- `Input`、`Output` 和匿名默认函数契约；
- `const`、`if / else`、`switch` 和 `return`；
- 字段/索引访问、对象/列表字面量、算术、比较、逻辑和三元表达式；
- 顶层/字段/枚举/返回契约检查、局部常量类型标注和 Zig codegen；
- 带文件名、行号和列号的编译诊断。

跨文件 import、Store Runtime、`app:db`、集合高阶操作、模板字符串和对象 spread 尚未进入 MVP。编译器会对这些能力给出明确诊断，不会静默生成含义不同的 Zig。

语言设计分别见 [RX design](docs/rx_design_doc.md)、[ZX design](docs/zx_design_doc.md) 和 [ZXC design](docs/zxc_deisgn_doc.md)。MVP 的实施范围和后续扩展点见 [ZX MVP compiler](docs/zx_mvp_compiler.md)。
