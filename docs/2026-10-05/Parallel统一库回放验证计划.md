# Parallel 统一库回放验证计划

## Intent：最终目标

第 378 阶段验证 RX Parallel 和 Task 在统一库链接、序列化、跨进程解码及重新生成代码后，仍保留源码执行时的结果、错误、所有权和真实线程行为。

## Data：可用证据

现有 `rx_parallel_runtime.zig` 对 18 种源码模式执行 75 项 Zig 测试，覆盖直接调用、service、Task、嵌套 Task、捕获和线程。现有 library replay 使用其他顺序流程夹具，未覆盖新引入的 Parallel IR。本阶段复用这些独立运行断言，不用生成器输出文本作为结果预言。

成熟实现参考 `tests/library/runtime/mixed.zig` 的 RX Program 链接和 `replay.zig` 的独立进程解码。库链接同时包含独立标量 ZX 导出与两个指向同一 RX 流程的公开导出；改变导出顺序，迫使函数和类型引用经历重编号。

## Edges：边界与限制

仅修改测试驱动、构建注册及本文档。生产 IO 工作正在并行进行，不将工作区验证称为固定 HEAD 全量回归。此阶段证明统一库存储及回放，不据此宣称外部包导入、再次发布或所有 Test262 已完成。线程测试沿用 allocator 记录线程身份，不使用时间阈值推断并行。

## Answer：交付格式与成功标准

- 为现有编译驱动增加 archive 路径，生成真实 `.zxlib`，不手造 Parallel IR。
- 独立 replay 可执行程序只接收产物和导出名，解码后覆盖并释放输入 bytes，再生成源码；流程推导所在进程已结束。
- 正序和逆序产物各选择不同别名回放；运行同一套 18 种模式、每轮 75 项宿主断言，新增 150 项执行组合。
- 每次解码比较重新编码结果，验证确定性；生成前调用 validateIr。
- 运行新专项及原源码专项，归档日志、源码草稿和 WIP 基线指纹；发现生产缺陷才向实现聊天反馈。完成后单独 commit/push。

```mermaid
flowchart LR
 RX[真实 RX 与 ZX] --> Infer[项目推导]
 Infer --> Link[标量与两个 RX 导出链接]
 Link --> Archive[统一库产物]
 Archive --> Replay[独立回放进程]
 Replay --> Zig[生成 Zig 与 ABI]
 Zig --> Host[现有宿主断言]
```

```mermaid
flowchart LR
 Bytes[产物字节] --> Decode[解码持有数据]
 Decode --> Poison[覆盖并释放输入字节]
 Poison --> Export[按名称选择导出]
 Export --> Validate[IR 校验]
 Validate --> Execute[结果 错误 分配失败 线程]
```

## 自我复核

当前是实施计划。执行组合复用已有 75 项断言，不把新回放路径算作新增语言语义，也不靠增加输入排列宣称 Test262 覆盖扩大。只有真实执行成功后才能填写结果。

## 第 378 阶段执行记录

已完成 18 种模式 × 正逆两种链接顺序，共 36 条独立产物回放路径。正序选择 workflow 导出、逆序选择 alias 导出；同库额外加入独立标量函数，覆盖链接函数重编号。各产物在独立进程中读取、解码、重新编码比较、覆盖并释放输入 bytes，然后按名称选择导出，验证 IR 并重新生成 Zig 与 ABI。

实际运行 `cd packages/test && zig build test-rx-parallel --summary all`，退出 0：**258/258 步骤、225/225 Zig 测试通过**。其中原有源码路径 75 项，新增回放路径 150 项；后者是同一套独立断言在不同编译路径下的执行组合，并非新增 150 种语言语义。日志见 [首轮结果](Parallel统一库回放测试草稿/首轮结果.txt)。

覆盖直接 Call/service、Task、嵌套 Task、首错误与首分配失败、输入求值错误、未捕获父变量、借用父值、嵌套借用和真实线程。所有权断言继续包含不修改输入、输出不别名、旧结果跨后续请求存活及逐次分配失败；线程分支仍使用真实 allocator 线程记录。编码确定性与解码 bytes 独立性是驱动中的强制断言，不另增加 Zig test 计数。

构建入口：`test-rx-parallel-runtime` 仍只跑源码路径，`test-rx-parallel-library` 跑统一库回放，新增 `test-rx-parallel` 聚合两者并由原有根 test 依赖接入。未修改生产实现，未发现需反馈的生产缺陷。

验证时 HEAD 为 67882f79，工作区另有实现聊天正在编辑的 IO/IR 改动；成功执行后记录相关文件 SHA256，见验证状态 JSON。未运行根全量回归，不声称对固定 HEAD 或 IO 能力完成验证。

复核：编译驱动与回放进程严格分开，没有用保留原始推导对象替代产物加载；回放后执行现有数值、错误和线程预言。首轮构建前修正辅助函数 Contract 类型所属模块，未产生编译失败。当前仍缺 Parallel 作为外部编译包导入及再次发布后的对应验证，留作下一阶段。
