# IPv6 序列化分配错误修复

## Intent：最终目标

让纯内存 IPv6 序列化在分配失败时保留 OutOfMemory，并避免为短且有固定上限的文本维护动态写缓冲。

## Data：可用证据

独立测试会话阶段 405 的 URL 原语回归在 std.testing.checkAllAllocationFailures 中发现 WriteFailed；堆栈表明 Io.Writer.Allocating 在 drain 中转换了底层分配错误。其他 129 项通过，没有解析错误或泄漏证据。

## Edges：边界与限制

IPv6 最长文本为八个四位十六进制段加七个冒号，即 39 字节。零压缩只会缩短结果。此内部 serializer 不写外围方括号，因此固定栈缓冲足够；不引入任意输入长度限制，不改变解析或规范化行为。

## Answer：修复与成功标准

先在 8×4+7 字节栈缓冲中序列化，再一次性 allocator.dupe 返回结果。格式写入超界为逻辑不变量，实际可失败点只有最终分配。运行反馈提供的 test-url-primitives 定向回归，保留 OOM 注入证据，不新增测试或运行全量测试。

```mermaid
flowchart LR
  Address[八段u16地址] --> Fixed[39字节栈缓冲]
  Fixed --> Copy[一次分配返回]
  Copy --> Result[字符串或OutOfMemory]
```

```mermaid
flowchart LR
  Runs[选择零压缩区间] --> Write[固定缓冲写入]
  Write --> Slice[有效字节切片]
  Slice --> Owned[调用方拥有的字节]
```

## 验证与自我复核

`zig build test-url-primitives --summary all` 定向目标通过：7/7 步成功、131/131 项通过，包含分配失败注入。正式测试由独立会话维护，本次未新增或修改测试文件。结果见 [回归记录](IPv6序列化分配错误修复/定向回归结果.txt)。

固定缓冲大小来自八段 u16 的十六进制表示上限，不来自具体样例。catch unreachable 仅用于无法超过该上限的固定格式输出，最终 allocator.dupe 的分配失败正常传播。未运行全量测试；本修复不扩大完整 URL 功能的完成范围。
