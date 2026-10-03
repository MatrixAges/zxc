# zxc workflows

Workflow 源码位于 `tsflows`，由 Bun 和固定版本的 `@jlarky/gha-ts` 生成到 `workflows/*.generated.yml`。不要直接修改生成的 YAML。

```sh
bun install --cwd .github --frozen-lockfile
bun run --cwd .github build
bun run --cwd .github check
```

依赖和 `bun.lock` 独立于应用工作区。CI 固定 Bun 1.3.10、Zig 0.16.0，第三方 Actions 固定提交；生成一致性检查失败时需要重新生成并提交 YAML。

构建覆盖 Linux musl、macOS、Windows GNU 的 x86_64/aarch64，各自在对应 runner 上构建、运行现有 quote 示例并上传 artifact。产物为 tar.gz 和 SHA256；解压后保持 bin/share 目录相对位置。下载后的 Unix 程序权限由 tar 保留。工作流不自动创建 release 或版本标签。

Windows ARM64 runner 使用经过 SHA256 校验的 x64 Zig 0.16.0 工具链，通过系统兼容层运行，规避[上游 ARM64 工具链 TLS 崩溃](https://codeberg.org/ziglang/zig/issues/31865)。zxc 和示例均显式指定 `aarch64-windows-gnu`，实际执行及归档仍为 ARM64。其他目标使用对应宿主的 Zig。

本地分发构建：

```sh
zig build dist -Doptimize=ReleaseSafe --prefix .zxc/local_dist
```

该步骤只构建并安装 CLI、标准库和许可证，不执行目标平台程序。允许传入 `-Dtarget` 交叉编译。本机对应目标可执行完整打包入口，例如：

```sh
ZXC_TARGET=x86_64-macos bun .github/scripts/package.ts
```

包内 CLI 的源码分析功能不要求启动 Zig；`zxc build` 生成应用仍要求 PATH 中有 Zig 0.16.0。正式分发包不包含 Zig 本身，也不包含 Z3 或 FPGA 工具链。
