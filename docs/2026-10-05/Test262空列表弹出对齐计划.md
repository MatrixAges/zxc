# Test262 空列表弹出对齐计划

## Intent：最终目标

保留 pop/S15.4.4.6_A1.1_T1.js 的两组完整可观察断言：新建空数组与 [1,2,3] 清空后均弹出空结果、剩余长度为零。

## Data：可用证据

原文完整正文仅四个断言：每次 pop 返回 undefined、每次列表长度为 0。第二次 x.length=0 是准备输入；没有写入描述符、副作用调用或对象身份断言。ZX 已有消费式 pop 和 splice，返回新列表及业务结果，空弹出为 optional null。

## Edges：边界与限制

这是 adapted：JS 数组构造改为 typed list，长度清空准备改为显式 splice 删除原元素，undefined 改为 optional null；不宣称支持可写 length、Array 构造函数或 JS undefined。两组原始数据都保留，不能只留第一组空数组。不把普通结果替换当作动态属性模型测试。

## Answer：交付与成功标准

以可变输入运行真实 splice 后 pop，返回删除项、剩余列表和弹出值；完整列表比较包含原来的长度断言，删除项作为额外控制。新增单元素、非空、部分清空、重复和逆序输入，使恒返回空结果的实现不能通过。Debug/ReleaseSafe、生成一致性与覆盖审计通过后提交push。

```mermaid
flowchart LR
    U[原文两种空数组来源] --> A[显式记录准备操作与空值适配]
    A --> P[真实 ZX pop]
    P --> R[空结果与剩余长度完整断言]
```

```mermaid
flowchart LR
    I[原列表和删除数量] --> C[独立拥有副本]
    C --> S[splice 清空或部分删除]
    S --> P[pop]
    P --> O[removed rest popped]
    O --> E[独立预期与输入不变检查]
```

## 执行结果与自我复核

一份原文 SHA 与固定 index 一致，严格/非严格两次原 harness 执行通过。首次 Debug 因 const 定义与解构之间缺分组空行而被格式门禁拒绝；修正生成器后，最终 Debug 和 ReleaseSafe 均退出 0，14/14 步骤、8/8 用例通过。包级 TypeScript 检查、生成一致性和覆盖审计均通过。

本次保留原文两组共四个结果断言，并明确输入准备和空值表示的语言差异。额外 deleted 数组验证清空准备确实发生，单元素、非空、部分清空、重复、逆序与零值使固定返回 null 不可能通过。collections 运行器核对原输入副本不变。该测试不验证 JS 属性赋值机制，也没有把它标为 equivalent。

审计为 catalog 80133、linked cases 4936；reviewed 2203（adapted 691、equivalent 103、excluded 1409），unreviewed 51394。新增八个执行输入只对应一份完整上游适配。
