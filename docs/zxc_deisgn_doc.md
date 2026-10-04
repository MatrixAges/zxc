# ZXC 设计文档

## 导入、导出与库消费

**Intent**：以 Node.js 的包公开接口机制和 pnpm 的依赖、workspace 机制为参考，统一 zxc 库的开发、发布与消费。

**Data**：参考 [Node.js Packages](https://nodejs.org/api/packages.html)、[pnpm Workspace](https://pnpm.io/workspaces) 与 [pnpm 依赖结构](https://pnpm.io/symlinked-node-modules-structure)。完整规则及实现状态见 [统一库设计](2026-10-05/统一库设计.md)。

**Edges**：沿用 `pkg.yaml` 和其内 workspace 配置。包名与子路径通过依赖实例及 `exports` 解析，包内实现默认私有；共享存储不合并不同包实例的类型和 Store 身份。RX 编排与 ZX 逻辑属于同一模块的内部实现。所有消费仍在编译期静态联结，遵守 zero runtime。

**Answer**：交付统一公开导出表、可复现的依赖解析与同一份库的 zxc/Zig 消费。验收覆盖 workspace 与发布包的 import 一致性、私有路径限制、未声明依赖、版本隔离及搬迁消费。设计目标不等于当前已实现范围。

## ZX 生成目录

ZXC 将项目根目录下的 `src/` 视为 ZX 源码根目录，将根目录下的 `.zxc/` 视为 Zig 生成目录。默认生成路径必须满足以下规则：

```text
src/<relative-path>/<name>.zx
→ .zxc/<relative-path>/<name>.zig
```

`src/` 本身不会出现在生成路径中。源码在 `src/` 内的目录层级和文件名必须保持不变，只把 `.zx` 扩展名替换为 `.zig`。

例如：

```text
src/order/create.zx
→ .zxc/order/create.zig

src/user/profile/update.zx
→ .zxc/user/profile/update.zig
```

ZXC 在写入生成文件前自动创建 `.zxc/` 下缺失的目录。`.zxc/` 只保存编译产物，不属于源码，不应提交到版本控制。

项目根目录以执行 `zxc` 时的当前工作目录为准。输入文件必须位于项目根目录内；位于 `src/` 之外的项目内 `.zx` 文件按项目相对路径生成，例如：

```text
tests/fixtures/order_quote.zx
→ .zxc/tests/fixtures/order_quote.zig
```

显式传入 `--out <path>` 时，使用指定路径覆盖默认映射规则：

```bash
zxc src/order/create.zx --out /tmp/create.zig
```
