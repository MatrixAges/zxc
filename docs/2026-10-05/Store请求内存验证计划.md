# Store 请求内存验证计划

## Intent：最终目标

针对 7149e3e5 引入的生成 State.Request，验证请求内存何时释放、何时转交 State，以及提交后返回值和旧快照的存活。该计划作为并行任务运行阶段之后的续作入口。

## Data：现有证据与真实缺口

已阅读 `packages/test/build/rx_store_runtime.zig`、`tests/rx/runtime/store/dual/emit_state.zig`、memory 下的 state/readonly/failure 宿主测试，以及 `packages/genz/src/zx/state/request.zig`。

现有 memory 测试使用同一个长期 arena，调用 `application.execute(&arena, input, &state)`。它们证明状态连续、单 Object 提交和旧值保留，但没有经过新的 `State.request()`、`Request.execute()`、`Request.deinit()` 和 `State.deinit()` 内存交接链。旧测试通过不能证明独立请求 arena 的存活与回收正确。

当前生成器行为：Request 从 State 的底层 allocator 建立独立 arena；首次非空提交时先在 State arena 分配 Region，随后发布值；Request.deinit 将整块请求 arena 交给 Region。未提交请求直接释放。State.deinit 释放保留请求 arena，最后调用方再释放 State 自身 arena。

## Edges：边界与限制

只添加测试、构建注册和文档，不擅自实现长期回收算法。当前设计保留已提交请求直到 State 结束；不把中途未回收判为泄漏，也不据此声称已经有界。State 必须晚于其 Request 销毁，不使用非法生命周期制造失败。现阶段不假定支持并发 Store 请求。

动态返回值需要在其请求或保留 Region 的合法存活期内检查。只读请求释放后不得再读取返回指针；通过底层 allocator 的存活字节和泄漏检测判断释放，而非解引用已释放内存。

## Answer：实施路径与成功标准

1. 复用 dual 编译驱动和真实 Store/ZX 夹具，继续由生成器生成 application、types、State 和依赖清单。
2. 新增 Request 宿主测试，走公开的 request/execute/deinit 链；先覆盖连续提交后旧快照与返回结果仍有效，再覆盖两个 State 隔离。
3. 复用 failure 项目，区分首调用失败未提交与先提交后续失败；前者请求销毁后释放全部请求数据，后者保留已发布数据且后续请求可继续。
4. 空提交、多 Object 提交拒绝和只读 Object 拒绝必须在注册 Region 前完成，不改变已发布指针。
5. 使用实际分配统计检查只读/未提交请求释放、提交请求保留，以及 State 和父 arena 销毁后的完全释放；补逐次分配失败，特别关注 Region 注册失败不得先发布值。
6. 增加独立请求长序列与多次执行检查，但不把有限次数当作长期有界证明。

```mermaid
flowchart LR
 State[应用 State] --> Request[独立请求 arena]
 Request --> Execute[真实 RX 执行]
 Execute --> None[无提交或提交前失败]
 Execute --> Commit[首次有效提交]
 None --> Free[Request.deinit 释放]
 Commit --> Region[State Region 接管]
 Region --> End[State.deinit 释放请求 arena]
```

```mermaid
flowchart LR
 Input[请求输入] --> Result[新值与返回结果]
 Result --> Publish[Store 槽位发布]
 Publish --> Borrow[后续请求与旧快照读取]
 Borrow --> Lifetime[受 State 生命周期约束]
```

## 自我复核

本文件是基于当前源码的缺口核对与后续计划，不是已执行测试报告。新的 Request 测试尚未添加，不能增加覆盖计数。实施前应重新核对生产实现、已有测试和实际生成模块，避免沿用过时状态。

## 第 377 阶段执行记录

已完成上述请求链专项，新增 19 项 Zig 宿主测试：request 8、request_failure 6、request_registration 1、request_readonly 4。正式文件在 `packages/test/tests/rx/runtime/store/memory/`，通过已有真实项目编译驱动生成 application、State、初始化器与依赖模块，再由 Node 驱动 Zig 执行。新增完全只读入口，覆盖没有 retained Region 的生成分支。

- 三个已销毁 Request 的返回值与旧快照仍正确；32 次写入后最早快照仍有效，两个 State 隔离，两个 Request 同时存活但顺序执行时读取最新槽位。
- DebugAllocator 的实际存活字节证明：空提交、多 Object 拒绝、提交前失败释放独立 arena；64 次只读请求每次回到基线；成功提交及后续失败的已发布数据保留；State 与父 arena 销毁后归零。
- 首次失败、后续失败及恢复均走 Request.execute/deinit，另外对连续提交、两类失败恢复、只读执行做逐次分配失败枚举。
- Region 登记故障注入只让父 arena 的下一次扩容/分配失败。Request 刚创建的空 arena 改用独立正常 allocator，隔离候选值分配与登记失败；没有替换 State、validate、apply 或 commit。每次请求都需登记新 Region，以父 arena 容量加一作为有限上界，实际触发 OOM 后确认两个发布指针均未改变；解除故障后请求成功。
- 接入时出现两处测试问题：enum 的 union 名称需 Zig 转义；只读夹具的 read_pair 参数应为 counter.value 而非整个对象。均按已有真实接口修正，不属于生产缺陷。

在 `packages/test` 运行 `zig build test-rx-store-runtime --summary all`，退出 0：**30/30 构建步骤、39/39 构建图 Zig 测试、7/7 Node 宿主组**通过。7 组内部又编译执行 **31/31 Zig 测试**（12 项原有、19 项新增），与构建图 39 项分开统计，见 [最终日志](Store请求内存测试草稿/最终回归结果.txt)。Zig fmt 与本阶段 diff 检查通过。

验证基线为 a1d928f7 加实现聊天正在进行的 I/O 相关生产改动（包括 State.Request 生成器可选 io 参数）。本阶段夹具均为原有纯 Store 流程；记录当前文件指纹，不将结果称为固定 HEAD 或 I/O 功能通过。未执行根全量回归，也未发现需反馈的生产缺陷。

本次仅验证既定的请求 arena 接管策略，没有实现或证明长期有界回收；只读返回值在 Request 存活期内检查，未解引用已释放指针。上方原始计划中的“尚未添加测试”是实施前状态，以本节实际执行记录为准。
