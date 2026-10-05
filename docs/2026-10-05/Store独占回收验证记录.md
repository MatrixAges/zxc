# Store 独占回收验证记录

## Intent：最终目标

验证静态可证明独占的 Store 更新在显式借用结束后释放历史请求区域，同时保留当前区域根、借用写入与旧宿主契约。对应阶段 399。生产依赖已由实现会话提交为 `0dafeb1d feat: reclaim retired Store regions after proven owned writes`。

## Data：证据与覆盖

新增 `test-store-reclamation`，真实 RX/ZX 双 Store 夹具经项目推导、模块生成、初始化生成和 State 生成，再编译 Zig 宿主实际执行。生成与宿主均显式使用所选优化模式。

新增 22 项：独占及根保留 13、借用 3、只读 2、失败恢复 4。另重跑上一阶段共享引用 16 项。Node 外层启动器不计为新增测试。

Debug、ReleaseSafe 均 38/38 宿主测试通过，15/15 构建步骤通过，退出 0；两模式 4096 次请求的清理后存活分配最大采样均为 736 字节。额外 Debug 回归完成 70 项 Store 宿主测试、48 项 Gateway 分析测试和 86 项真实 HTTP 场景，44/44 步，退出 0。优化模式不重复计数，已有用例不计入新增。

### 独占与根保留

`State.can_release_retired` 必须为 true。使用正常 request.execute 驱动嵌套服务、ZX setter 和提交，每轮在请求存活期间消费输出，结束 Request 后调用 releaseRetired。连续 4096 次固定大小更新，检查左/右值、列表内容与分配器累计申请减已释放字节，存活分配必须不超过 65536 字节；日志记录清理后采样最大值。重复 releaseRetired 不改变存活分配；初始化后、首次写入前调用也安全。

两个当前 Store 分别来自不同请求时，两区域都须保留；只替换左根后，旧左区域必须实际释放，右根仍有效。同一请求分别创建两个独立列表并提交两槽时，只替换一槽不能释放仍承载另一根的区域；两槽都替换后，该区域必须释放。这里共享的是请求区域，不是宣称两个值之间存在共享引用。

空 State.commit 与被拒绝的多 Object State.commit 不得关闭后续回收；测试以之后实际 freed_bytes 增长验证。成功的直接 State.commit 则必须关闭回收，在后续调用 releaseRetired 后仍保留旧输出。旧宿主不调用清理时，也继续保持跨请求输出借用。

### 保守路径与失败

新增 borrowed setter 夹具，保留旧 history 列表，只构造新对象外壳；其 can_release_retired 必须为 false，调用清理不得释放历史区域。只读程序同样不生成可回收写区域，64 次读取后活分配回到初始化基线。

失败夹具分别在第一个 setter 失败和前一 Call 已提交、后一 Call 失败两处触发索引错误。64 次失败请求后每轮清理，检查未提交槽不变、已提交槽正确，并在最后一次合法请求恢复执行。所有关键生命周期遍历 OOM；DebugAllocator 验证状态销毁后活字节归零。

### 测试夹具地址稳定性修正

首轮使用跨目录 fixture 导入，被 Zig 的模块根范围拒绝；将测试生命周期夹具保留在本宿主目录后继续执行。

随后发现 fixture 初始化局部 State 再按值返回会改变地址，但 State.initialize 建立的槽位指针指向原 State 字段。新 execute 测试出现错误初值和崩溃，由测试夹具造成。修正为独立分配稳定的 State 地址，销毁时依次释放 State 保留区域、State、arena 与 arena 容器；同样修正上一阶段 aliases 夹具并重新执行其 16 项测试。没有修改生产实现来容忍无效宿主指针，保留失败日志供审查。

## Edges：限制与自我批判

清理前不读取或继续持有可访问的旧输出；测试只保留验证所需的标量。旧宿主和 fallback 测试明确不启用实际清理。根保留测试直接调用生成 Request.commit，但所有新值及列表均由该 Request 自己分配，符合独占新值前提。

65536 字节是固定大小示例在 4096 次请求下的回归上限，不是任意程序的内存保证；日志的最大值采样于每次清理之后，不是单请求瞬时分配峰值。当前仍活跃的请求区域可能保留临时数据，业务本身增长的数据也不应释放。

borrowed 源码只覆盖借用列表，尚未穷举字符串、对象深层别名、原生来源和所有函数摘要组合。没有篡改归档摘要；Gateway 的自动清理接入及真实 RSS 长期压测不由本宿主测试证明。通用共享 Store 回收和完整 Test262 仍未完成。

本轮发现的问题属于测试夹具，未发现新的生产缺陷，没有向实现会话发送修复消息。生产实现由指定会话负责；已确认依赖提交后再提交本阶段测试。

## Answer：复现与交付

在 `packages/test` 执行：

```sh
zig build test-store-reclamation test-store-alias-lifetime --summary all
zig build test-store-reclamation test-store-alias-lifetime -Doptimize=ReleaseSafe --summary all
zig build test-rx-memory-state test-rx-store-io test-gateway --summary all
```

最终版本、退出码与用例数写入 [结果 JSON](Store独占回收验证/结果.json)。[计划](Store独占回收验证计划.md)包含 IDEA、架构图及数据流图；日志和草稿在 [配套目录](Store独占回收验证/)中。完成验证后独立提交推送。
