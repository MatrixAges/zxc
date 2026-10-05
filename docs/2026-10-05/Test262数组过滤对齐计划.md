# Test262 数组过滤对齐计划

## Intent：最终目标

继续对齐 Array.prototype.filter 的原文语义，将能由现有 typed dense list 表达的完整断言接入真实 ZX 编译运行测试。

## Data：可用证据

当前 filter 有单元素参数、内联且不捕获外部变量的布尔表达式回调；IR 契约明确该限制。上游 filter 目录共 242 份文件，其中 240 份尚未正式映射；先按锁定 index 验证原文 SHA-256 并执行原 harness，再逐份审阅候选。

## Edges：边界与限制

不得把索引参数替换成元素值，不能丢掉原文的 sparse/prototype/this/coercion 或回调调用次数断言。只给完整保留核心断言的文件添加 adapted 记录，不以多参数语法裁剪宣称 equivalent。其他原文保持待处理，不批量 excluded。

## Answer：交付与成功标准

按谓词、空列表及执行失败观察等实际职责建立测试目录。保留原始输入与断言，并配套能击穿错误实现的控制输入。复用 collections 运行器，Debug 与 ReleaseSafe 专项通过，生成一致性与覆盖审计通过后提交推送。

```mermaid
flowchart LR
    U[上游固定原文] --> R[逐份断言审阅]
    R --> C[公开集合契约对照]
    C --> T[ZX 测试与溯源记录]
```

```mermaid
flowchart LR
    I[动态输入] --> F[真实 ZX filter]
    F --> O[结果或执行错误]
    O --> A[独立预期和控制用例]
```

## 原文审阅结论

242 份原文哈希核验成功，480 次参考执行全部通过。唯一新增候选是 15.4.4.20-9-c-ii-10.js：保留一个形参、val > 10、原输入 [12] 及结果长度 1/元素 12；命名函数改内联表达式记为 adapted。已有 10-1/10-2 不重复登记。5-27/28、6-1 带反射断言，不能裁剪成空列表用例；9-c-ii-9 专门检查零形参不能补参数。其余涉及稀疏、this、索引、array-like 和真值转换的文件保留未处理。

本步只新增 predicate 一组：原文输入加空、全保留、全拒绝、阈值、重复值及双向混合顺序控制，共九个动态输入。整列表深比较同时核对长度与每个值；不把九个输入计成九份上游。

## 中途验证

新增九例和既有数组回调组的 Debug 专项已退出 0；生成一致性与覆盖审计通过。包级 tsc 发现两个既有驱动推断过窄：HTTP response 从 Buffer.from 推断 ArrayBuffer，但公开 respond 接受一般 Buffer；进程环境复制推断测试字段为必填但用例需要删除。分别补显式 Buffer 和 NodeJS.ProcessEnv 注解，运行逻辑不变，包级 tsc 最终退出 0。

ReleaseSafe 首次执行被共享工作区正在实现的 genz/value_call/root.zig:25 阻断：不存在 ir.Call 类型，CLI 本身无法编译，13/30 步成功。这不是 filter 断言失败，已附完整复现通知实现会话，未改动其工作中源码。全量 build_modes 同样遇到该错误；保留失败日志等待修复后复验。

## 最终验证与自我复核

实现会话已把 ir.Call 改为从表达式 union 取实际 call 类型。修正后的 ReleaseSafe 专项退出 0，38/38 用例通过（本次 filter 9 例，原 map/reduce 29 例），30/30 构建步骤成功。Debug 专项在该中途改动前已退出 0。包级 tsc 与生成 --check 最终通过，覆盖审计为 80125 个目录用例；上游 reviewed 2194（adapted 690、equivalent 103、excluded 1401），unreviewed 51403，linked cases 4934。

输入数组直接作为动态参数传入，被测源码只使用真实 filter；预期九组数组逐一列出，不用被测输出生成预期。collections 支撑器验证输入副本不变和完整输出，能区分恒 true/恒 false、阈值错误、倒序、排序、去重等错误实现。唯一原文映射完整保留长度与值两个断言，其余八例是本地控制而非八份新增上游。

全量回归在本次新增 suite 前已启动，不能声称它包含本次 filter 注册；本组执行证明来自独立专项。全量还记录了中途 genz 编译失败，尚未完成，不得用本组通过覆盖总入口结果。
