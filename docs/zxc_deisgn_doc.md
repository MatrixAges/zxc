# ZXC 设计文档

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
