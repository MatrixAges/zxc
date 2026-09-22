# zxc

zxc 是一个为 AI 设计的编译器，也可以表示一门为 AI 设计的编程语言。这个编程语言提供两种类型的代码文件：`.rx` 和 `.zx`。RX 是 XML 配置，负责编排流程和定义流量出入口；ZX 是类 TypeScript 的有限语法，负责承载单一、可静态验证的业务逻辑。

zxc 主要解决 a 生成的代码，没有架构，不可读的问题。从编译器层面规范 ai 写出健壮的代码，像设计芯片架构一样设计程序。

语言设计分别见 [RX design](docs/rx_design_doc.md)、[ZX design](docs/zx_design_doc.md) 和 [ZXC design](docs/zxc_deisgn_doc.md)。MVP 的实施范围和后续扩展点见 [ZX MVP compiler](docs/zx_mvp_compiler.md)。

正式包位于 `packages`：[dsl](packages/dsl/README.md) 提供通用语法定义与校验，[rx](packages/rx/README.md) 定义 `.rx` 标签、按文件路径注册模块并检查循环依赖。根目录运行 `zig build` 构建，`zig build test` 运行包内单元测试；MVP 参考实现位于 `legacy`。

[skills](packages/skills/README.md) 面向使用 zxc 编写应用的 AI，提供业务模块设计、消除循环依赖与应用验证指导。维护 zxc 本身的内部开发规则见 [AGENTS.md 的索引](AGENTS.md#项目规则索引)。
