### 获取编译器

当前文档采用从源码构建的方式。为此版本安装 Zig **0.16.0**，然后执行：

```sh
git clone https://github.com/MatrixAges/zxc.git
cd zxc
zig build
zig build zx-example
```

`zx-example` 会编译并运行仓库中的真实 ZX 示例。这些命令用于源码检出目录；具体应用的宿主可能提供不同的构建入口。

### 编译 ZX 文件

在源码检出目录中执行：

```sh
zig-out/bin/zxc packages/compiler/examples/quote.zx --out /tmp/quote.zig
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --check
```

编译结果是 Zig 源码，不会运行完整 RX 服务，也不会自动提供运行时。将生成模块接入 Zig 宿主时，需要编译器的 `zx_runtime` 支持模块。

### 选择职责边界

ZX 负责计算，RX 描述模块组合。在承诺可运行的服务之前，确认目标宿主已经实现应用所需的 RX 执行与状态行为。
