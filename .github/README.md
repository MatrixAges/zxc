# zxc workflows

Workflow 源码位于 `tsflows`，由 Bun 和固定版本的 `@jlarky/gha-ts` 生成到 `workflows/*.generated.yml`。不要直接修改生成的 YAML。

```sh
bun install --cwd .github --frozen-lockfile
bun run --cwd .github build
bun run --cwd .github check
```

依赖和 `bun.lock` 独立于应用工作区。CI 固定 Bun 1.3.10、Zig 0.16.0，第三方 Actions 固定提交；生成一致性检查失败时需要重新生成并提交 YAML。

构建覆盖 Linux musl、macOS、Windows GNU 的 x86_64/aarch64，各自在对应 runner 上构建并上传 artifact。产物为 tar.gz 和 SHA256，包含单个 zxc 与许可证；执行不依赖旁置 share 目录。下载后的 Unix 程序权限由 tar 保留。工作流不自动创建 release 或版本标签。

Windows ARM64 runner 使用经过 SHA256 校验的 x64 Zig 0.16.0 工具链，通过系统兼容层运行，规避[上游 ARM64 工具链 TLS 崩溃](https://codeberg.org/ziglang/zig/issues/31865)。ARM64 zxc 内嵌这套 x64 Zig，未指定目标时仍生成原生 ARM64 程序。其他目标内嵌对应宿主的 Zig。

分发校验只复制 zxc 到独立临时目录，清空 PATH 并设置无效的外部 ZIG_LIB_DIR，构建、运行已有 quote、std:encoding/std:crypto 和 Zig/C 原生模块示例。另读取生成文件头核对目标 CPU，防止 ARM runner 因能够执行 x64 程序而掩盖目标错误。默认包索引直接内嵌，读取时无需展开工具链。

本地分发构建：

```sh
zig build dist -Doptimize=ReleaseSafe --prefix .zxc/local_dist
```

该步骤构建包含官方 Zig 归档和 ZX 标准实现的 CLI，并安装许可证，不执行目标平台程序。构建工具根据目标宿主获取锁定的 Zig 0.16.0 官方 `.tar.xz`/`.zip`，校验 SHA256 后原样内嵌，不编译 Zig、不裁剪或重压缩。`-Dzig-archive=/absolute/path/to/archive` 可提供本地官方归档，避免构建时下载；归档必须匹配 zxc 宿主（Windows ARM64 使用已锁定的 x64 包）。完整资源保留，原生构建的 `--target` 仍支持 Zig 的交叉编译范围及其外部依赖边界。

版本锁定数据在 `packages/cli/build/toolchain/releases.json`。维护者可通过 `bun packages/cli/build/toolchain/update_releases.ts 0.16.0 <output.json>` 从官方索引重新生成 URL 与 SHA256；版本升级需同时审核 CI 版本、锁定文件及归档格式兼容性。当前四个 XZ 归档均为单个 LZMA2 块；首次解压需要数百 MiB 内存，热缓存不重复解压。

本机对应目标可执行完整打包入口，例如：

```sh
ZXC_TARGET=x86_64-macos bun .github/scripts/package.ts
```

用户无需安装 Zig，也无需在运行时下载工具链。首次 `zxc build` 将内嵌资源展开到用户缓存，后续按内容摘要复用。可用绝对路径环境变量 ZXC_CACHE_DIR 指定缓存根；默认使用平台用户缓存目录。构建环境仍需 Zig 来编译 zxc 本身。外部求解器、FPGA 工具和项目声明的系统原生依赖不属于内嵌 Zig 的范围。
