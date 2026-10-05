# NAPI 协议验证记录

## Intent：最终目标

验证 ZX/RX 原生 Node 插件的可执行契约，覆盖标量、复合值、错误恢复、内存复制与 Worker 状态隔离。对应《NAPI协议验证计划》，不将该阶段视为整个 NAPI 能力或 test262 目标完成。

## Data：可用证据

入口为 `packages/test` 中的 `zig build test-napi-protocol` 与 `zig build test-napi-protocol -Doptimize=ReleaseSafe`。真实 CLI 编译 17 个 `.node` 产物，Node `require` 后调用导出的 execute，不通过 JSON 中转。临时目录在结束时清理。

| 分类 | 场景数 | 内容                                                                      |
| ---- | -----: | ------------------------------------------------------------------------- |
| 标量 |    446 | void、bool、八种整数/浮点类型及字符串；参数数量、范围、错误类型输入、恢复 |
| 字节 |     45 | 六种长度与五种输入形态、视图偏移、双向修改独立性、非法输入                |
| 记录 |     31 | 枚举、可空字段、BigInt 数组、嵌套记录、缺失字段、getter 抛出与重入        |
| 属性 |      1 | **proto**、constructor、prototype 均生成可枚举自有数据属性                |
| 集合 |     20 | 顶层 nullable 与精确长度元组                                              |
| 状态 |     18 | 连续调用、无效输入后的状态、三个 Worker 独立初始化、GC 后调用             |
| 合计 |    561 | 同一组在两种优化模式运行，不重复计数                                      |

首轮未加入属性场景时 Debug 560 个场景通过。最终 Debug 与 ReleaseSafe 均通过 561 个场景，两个进程退出码均为 0；日志位于 `NAPI协议验证/Debug.log` 与 `NAPI协议验证/ReleaseSafe.log`。

## Edges：边界与限制

- u8 的全部 256 个有效值穷举；其余整数检查声明范围端点和相邻越界值。u64/i64 使用 BigInt，并覆盖超过 Number 安全整数精度的值。
- 浮点包括 NaN、Infinity、负零、极值和次正规量级；f32 按单精度舍入预期。字符串包含 NUL、中文、emoji、孤立代理码元和较长字符串，代理码元按 Node UTF-8 转换后的良构字符串比较。
- 五种字节输入形态为 Array、Buffer、Uint8Array、Uint8ClampedArray 和带偏移 Uint8Array 视图。宽 TypedArray、负数、小数、BigInt 与稀疏数组等输入必须拒绝。
- getter 抛出的 Error、普通对象、null 和数字均按身份/值验证原样传播，不能用统一包装错误替代；重入拒绝后执行恢复。
- Worker 串行创建和退出，各自初始 Store 为 3，主线程状态不受影响。设置 30 秒超时避免 Worker 意外挂起拖住测试。
- 主线程 GC 检查仅证明仍可访问的 execute 在该压力下可调用。模块缓存仍持有导出，未证明仅剩函数引用时的所有权或 finalizer 最终释放。Worker 正常退出也不能替代泄漏检测。
- 运行平台限当前 macOS/Node；不声称 Linux/Windows 实际加载已经验证。未涵盖异步调用、任意原生依赖、I/O/process 拒绝、watch 以及新增 TypeScript 模块声明。

## Answer：交付与成功标准

正式测试位于 `packages/test/tests/targets/napi/`，`build/napi_protocol.zig` 接入测试总入口。两种模式均通过，范围内 TypeScript 严格检查和 Zig 格式检查通过；本阶段独立提交推送。发现生产缺陷才通知指定实现会话；目前未发现。

## 自我批判

561 是输入与连续状态场景数，不是不同语言特性的数量。错误恢复包含额外断言，不据此再增加计数。类型转换预期来自公开契约和 JS 值语义，不通过读取生成结果再反填预期。复合值使用新的输入和期望对象，避免同一对象修改后同时改变两侧导致假通过。

此组仍不能覆盖全部生命周期与发布行为，剩余边界明确列出，后续必须继续补齐，而不是以本组通过宣称 Node 宿主已全面生产就绪。
