# RX 并行调用参考

## Intent：使用目标

在同一输入上并行计算互相独立的结果，等待全部分支结束后继续编排。

## Data：可用接口

```xml
<Module>
  <Parallel>
    <Call fn="map_values" in="$in" out="ctx.values" />
    <Call fn="sum_values" in="$in" out="ctx.total" />
  </Parallel>
  <Return value="{values: ctx.values, total: ctx.total}" />
</Module>
```

`fn` 指向 ZX 函数，`service` 指向 RX 模块，`module` 可调用已发布的编译模块。Call 的输入输出类型沿用统一推导与编译库契约。

```sh
zxc build main.rx --out app
./app '[2,3,7]'
```

完整示例在 [示例目录](RX并行调用/示例/main.rx)，配套实现说明和实际验证在 [实施计划](RX并行调用实施计划.md)。

## Edges：执行与能力边界

- 输入按声明顺序在父线程计算，分支只读取进入块前的绑定。兄弟 Call 不能互相引用输出。
- 直接 Call.out 在所有分支结束后可见，路径不能重叠。无 out 的 Call 也会执行并传播错误。
- 分支必须是纯计算。编译器检查可达调用闭包，拒绝 Store 能力和原生 external 调用。父线程可先读取授权 Store 快照并传入不可变数据。
- 所有线程结束后按声明顺序选择首个错误。线程启动失败时等待已经启动的线程再返回错误，不取消工作，也不降级为顺序执行。
- 每个分支启动一个原生线程；目前没有线程池或粒度优化。分配操作通过锁保护，计算部分并行；输出归父请求 arena 所有。
- 并行输入按借用处理，后续消费外层 owned 数据可能被所有权规则拒绝；不会深拷贝以绕过限制。
- Task 分支、Store 并发写入、原生副作用并发仍未实现。无原生线程的目标不能构建此能力。verify 与 FPGA 已支持通过纯度和独立性检查的 Parallel 数值子集，包含契约的程序继续遵守证明门禁，见 [纯计算证明参考](并行纯计算证明参考.md)。

## Answer：发布与消费

并行结构保留在统一编译库中，可以由 RX、ZX 和 Zig 消费；发布方式沿用普通模块：

```sh
zxc build pkg.yaml --mode lib --out published
```

IR 升级为版本 10；旧版本缓存会失效，旧编译库需用对应编译器重新发布，不能混用内部 IR 版本。

示例工作区的发布包和消费模块位于 `RX并行调用/消费/pkgs/parallel-example`、`RX并行调用/消费`。消费前在工作区执行 `zxc pkg install pkg.yaml --offline`，然后构建消费模块。原生宿主需让输入和父 arena 覆盖输出使用期；传入 allocator 不必自行支持多线程，生成代码在并行范围内包装分配互斥。宿主仍不能同时在别处无同步地使用同一个底层 allocator。

## 自我复核

纯调用并行是完整 Parallel 目标的一个阶段。线程数、内存寿命、错误顺序有明确契约，但尚不支持取消、调度策略、分支 Task 返回或共享状态提交；不能从应用执行成功推断这些能力已经完成。
