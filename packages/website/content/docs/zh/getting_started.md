### 获取编译器

当前文档采用从源码构建的安装方式。这个修订版本需要 Zig **0.16.0**，安装后执行：

```sh
git clone https://github.com/MatrixAges/zxc.git
cd zxc
zig build
zig build zx-example
```

`zx-example` 会编译并运行仓库中真实的 ZX 示例。这些命令面向源码仓库；应用的宿主可能提供不同的构建入口。

### 编译 ZX 文件

在源码仓库中执行：

```sh
zig-out/bin/zxc packages/cli/examples/quote.zx --out /tmp/quote.zig
zig-out/bin/zxc fmt packages/cli/examples/quote.zx --check
```

编译结果是 Zig 源码。它不会运行完整的 RX 服务，也不会自动配置运行时。将生成模块集成到 Zig 宿主时，需要提供编译器的 `zx_runtime` 支持模块。

### 选择边界

用 ZX 编写计算，用 RX 描述组合。在承诺服务可以运行之前，先确认目标宿主实现了应用需要的 RX 执行与状态行为。

### 阅读完整计算

仓库中的 `quote.zx` 示例明确声明金额、折扣、启用标记和浮点系数：

```typescript
export type Input = {
  amount: u64;
  discount: u64;
  enabled: bool;
  factor: f32;
};

export type Output = {
  amount: u64;
  factor: f32;
};

export default function (in: Input): Output {
  const adjusted_factor = in.factor * 0.5;

  if (!in.enabled || in.discount > in.amount) {
    return { amount: in.amount, factor: adjusted_factor };
  }

  return { amount: in.amount - in.discount, factor: adjusted_factor };
}
```

守卫条件避免在折扣超过金额时执行无符号减法。两个分支都会将系数减半。输入启用标记为真、金额为 `100`、折扣为 `15`、系数为 `2.0` 时，预期结果是金额 `85`、系数 `1.0`。

这是根据源码推导的预期结果。要验证本机环境中的执行行为，请运行仓库的可执行示例，或把生成模块接入自己的宿主并传入上述输入。

### 完成第一个里程碑

此时应分别得到编译器二进制、生成的 Zig 源码，以及能够运行的仓库示例。不要混淆这三类结果：格式检查验证源码呈现方式，编译检查程序，宿主执行才会运行生成结果。

接着阅读[编写逻辑](/docs/write-logic)与 [Zig 宿主集成](/docs/host-integration)。
