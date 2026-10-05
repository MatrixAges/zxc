# Store 共享引用验证记录

## Intent：最终目标

针对长期回收必须保持的引用存活边界建立回归：其他 Store、当前新值或宿主旧输出仍引用某请求区域时，该区域不能因原槽位被覆盖而释放。对应阶段 398。

## Data：测试结构与证据

新增 `test-store-alias-lifetime`，接入总 test。复用已有真实 RX 双 Store 项目编译工具，生成正式 State、Request 与初始化模块，再由 Zig 宿主执行生成的 commit、请求销毁和状态销毁接口。测试源码位于 `tests/rx/runtime/store/memory/aliases`，按跨请求、交叠请求、失败路径拆分。

新增 16 项 Zig 测试，不把外层 Node 启动检查重复计入用例数量：跨请求 7、同请求/交叠请求 5、拒绝与恢复 4。

最终新增组 Debug 与 ReleaseSafe 均 16/16，5/5 构建步骤，退出 0。既有宿主回归在两模式均完成 14 个宿主、70/70 Zig 测试、29/29 步，退出 0。不同优化模式不重复计数；70 项旧回归不计入新增。ReleaseSafe 日志中的每个宿主标题都标记 ReleaseSafe，运行器为各模块显式传递优化选项。

跨请求测试先在请求甲分配动态列表并发布左槽，再在请求乙把它的整片、内部子片、空尾片或单元素子片发布右槽。随后覆盖左槽，核对右槽仍可读；再覆盖右槽，核对宿主持有的早期对象仍可读。大列表使用 4096 项，保留内部 7..4001 范围，间隔 64 次其他写入后再核对。

同请求测试连续发布左槽、共享到右槽、把更深子片重新写回左槽，再让仍交叠的请求二共享该子片到右槽。分别先结束生产请求、先结束消费请求，检查中间提交的旧对象和最终两个槽均保持内容。

拒绝测试以多 Object 同时提交触发 MultipleStoreObjects，覆盖本请求尚未成功提交以及已经成功发布共享右槽两种情况。随后空提交不能破坏当前状态，下一请求仍可继续发布旧值的子片。正常及失败链路遍历全部分配失败，DebugAllocator 的两项独立测试检查最终销毁后 total_requested_bytes 为零。

### 宿主优化模式修正

检查发现原 Node 宿主运行器执行 `zig test` 时未传优化选项，外层 `-Doptimize` 只控制生成工具。新增 `ZXC_TEST_OPTIMIZE` 传递，校验四个 Zig 标准优化模式，并向宿主、每个生成模块、ABI 及可选标准库/fixture 模块传入对应 `-O`。现有 rx_store_runtime 和 rx_store_io 构建入口也同步传递 optimize，缺省仍为 Debug。日志标题记录实际请求的模式。

该修正意味着旧运行器的历史外层 ReleaseSafe 构建不能单独证明宿主以 ReleaseSafe 执行；本轮两模式重新执行相关宿主，证据以本目录日志为准。

## Edges：边界与自我批判

Store 通用长期回收仍未完成，本轮不断言固定内存上限，也不把最终释放等同于长期有界。所有共享数据来自生成的 Request 自有 arena，宿主没有把即将失效的栈内存当成持久数据发布。

共享发布使用生成的 Request.commit 直接构造，验证的是状态容器与内存生命周期；它不是新增 ZX setter 或完整 Gateway HTTP 链路的端到端测试。旧有 setter/请求/IO 回归另行执行。当前裸借用持续到 State 结束，未来若新增显式借用结束接口，应另加按新接口运行的回收测试。

仅覆盖两个 Store 的 u64 列表及切片，未覆盖任意深层对象图、并发写入、字符串/可选值的区域来源与通用静态释放证明。实现会话正在探索所有写入均可证明独占时的有限回收路径，不能将这种子集提升为所有 Store 的回收完成。

本轮未发现新的生产缺陷，没有向实现会话发送修复消息。发现并修复的是本测试包的宿主优化模式传递。

## Answer：复现与交付

在 `packages/test` 执行：

```sh
zig build test-store-alias-lifetime --summary all
zig build test-store-alias-lifetime -Doptimize=ReleaseSafe --summary all
zig build test-rx-memory-state test-rx-store-io --summary all
zig build test-rx-memory-state test-rx-store-io -Doptimize=ReleaseSafe --summary all
```

执行退出码、测试数量和基线版本写入 [结果 JSON](Store共享引用验证/结果.json)。[计划](Store共享引用验证计划.md)包含 IDEA 与架构、数据流图；[配套目录](Store共享引用验证/)保存日志和源码草稿。完成检查后独立提交推送。
