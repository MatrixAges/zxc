# loop 使用参考

## Intent：最终目标

`loop` 根据当前状态决定是否继续，作为表达式时返回同类型的状态；只需执行副作用时，可以直接作为语句调用，省略 `const state =`。集合逐项转换用 `map`，筛选用 `filter`，有限集合累积用 `reduce`；条件驱动的状态计算用 `loop`。不提供 `forEach`，也不增加通用 `for`、`while` 语句。

## Data：可用证据

`loop` 仅用于 ZX；RX 通过 Call 节点调用对应 ZX 模块，不允许在值中内联调用。已有示例覆盖先判断、后判断、分支更新、列表索引、嵌套对象、可选对象以及模块调用。[执行记录](状态迭代/执行记录.json)保存实际输入输出与生成证据。

自举表达式解析器已用 `loop` 替换三个调度列表。三份已有语法模块、2166 个解析位置与 Zig 参考解析器比较，AST、索引与诊断零差异，见[解析器驱动核对](状态迭代/解析器驱动核对.json)。这不是完整前端回归或完整自举完成证明。

## Edges：语法与所有权边界

- 第一个参数是初始状态，不能是 `void`；结果类型与初始状态相同。
- 第二个参数必须是内联规则对象，只能包含 `while` 和 `next`，或 `while` 和 `do`；不能展开、重复字段或同时提供两种步骤。
- 两个回调各有一个状态参数，不能捕获外层局部值。需要的数据显式放入初始状态。
- `while` 返回 `bool`；`next`、`do` 必须使用状态更新块。
- 更新块可使用局部 `const`、元组解构、`if` 和 `switch`，更新目标必须属于当前状态参数。数值可使用复合赋值，列表索引保持越界检查。
- 更新块不能 `return`、写入 Store 或修改外层绑定；不提供 `break`、`continue`。提前结束可通过下一状态中的标记控制条件。
- 原有初值绑定保持借用语义，不能借此消费共享列表。直接返回独占结果的函数调用可作为临时初值交给循环；后续状态若变成借用，回边会按借用状态再次检查。
- 不会自动提交到 Store、并发执行或引入运行时代理。错误按已有规则传播。

## Answer：调用方式与成功标准

### 先判断再更新

以下程序在 `remaining` 为零时执行零轮。局部赋值描述下一状态；调用后仍可读取初值。

```typescript
export type Input = { remaining: u64 }

export type State = { remaining: u64, processed: u64 }

export type Output = { initial: State, result: State }

export default function (in: Input): Output {
  const initial: State = { remaining: in.remaining, processed: 0 }

  const result = loop(initial, {
    while: state => state.remaining > 0,
    next: state => {
      state.remaining -= 1
      state.processed += 1
    }
  })

  return { initial: initial, result: result }
}
```

### 先更新再判断

把 `next` 换为 `do`，先执行一次步骤，再判断更新后的状态。业务步骤必须能处理初始条件不成立的情况，不能假定条件已经检查过。

```typescript
const result = loop(initial, {
    do: state => {
        if (state.remaining > 0) {
            state.remaining -= 1
            state.processed += 1
        }
    },
    while: state => state.remaining > 0
})
```

### 只执行循环

不需要读取最终状态时，直接调用 `loop`。例如 `write` 是已导入的、输出为 `void` 的业务模块：

```typescript
loop({ items: in.items, index: 0 }, {
  while: state => state.index < state.items.length,
  next: state => {
    write(state.items[state.index])

    state.index += 1
  }
})
```

这两种形式使用相同的初值、条件和步骤规则。独立调用仍传播步骤中的错误，允许放在另一个循环的更新块内。内部状态继续参与每一轮计算，只有最终结果被丢弃；若需要最终状态，仍写 `const state = loop(...)`。普通非 `void` 函数和任务结果不能因此自动丢弃。

### RX 调用 ZX 模块

将上面的计数逻辑保存为 `count.zx`，RX 只连接输入和结果，不在属性值中执行 loop 或其他函数/方法调用。

```xml
<Module>
  <Call fn="count" args={$in} name="counted" />

  <Return value={ctx.counted} />
</Module>
```

### 生成与验证边界

编译器生成普通 Zig 循环。满足条件的对象、元组和可选聚合状态使用局部值；列表在版本与别名分析允许时首次写入隔离、后续复用。仍可观察的旧列表不能被原位覆盖。

这不表示所有业务调用、列表增长或嵌套列表操作都没有分配。应用交付应核对最终状态、初值保留、错误路径和实际生成结果，不能仅凭源码用了 `loop` 就宣称零复制。

公开名称为 `loop`，旧名称没有内置兼容入口。实现进展与尚未覆盖的优化见[设计记录](顺序遍历与状态迭代设计.md)。
