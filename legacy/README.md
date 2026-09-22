# Legacy MVP

此目录保留早期 ZX 编译器和测试，供正式版本开发参考。业务实现位于 `src`，原有集成测试及 fixture 位于 `tests`。迁移未修改源码和测试内容。

使用 Zig 0.16.0，在本目录运行：

```sh
zig build
zig build test
zig build run -- tests/fixtures/order_quote.zx
```

CLI 输出为 `zig-out/bin/zxc`，测试生成文件位于 `.zxc/tests/fixtures/`。构建及运行路径均相对于本目录。根项目的默认构建不包含此 MVP，正式实现放在 `packages` 中。

历史实现范围见 [ZX MVP compiler](../docs/zx_mvp_compiler.md)，迁移记录见 [MVP 归档迁移](../docs/2026-09-22/MVP归档迁移.md)。
