ZX 让列表转换和所有权显式可见。输入集合应视为借用数据；需要进行消耗式操作时，先克隆出自己拥有的值。

### 不用通用循环完成转换

```typescript
export type Input = u64[][]
export type Output = u64[]

export default function (in: Input): Output {
  return in.map((row) => row.filter((item) => item > 2).reduce((sum, item) => sum + item, 0))
}
```

`map` 和 `filter` 接受单参数回调；`reduce` 接受双参数回调和显式初始累加值。回调体必须是表达式，不能捕获外部值或 Store 句柄，但可以调用导入的函数。

### 按状态条件重复执行

`loop` 接收初始状态和内联规则，返回同类型的最终状态。`while` 先判断，`next` 在条件为真时产生下一状态；不依赖预先构造的计数列表。

```typescript
const result = loop(initial, {
	while: state => state.remaining > 0,
	next: state => {
		state.remaining -= 1
		state.processed += 1
	}
})
```

将 `next` 换成 `do`，则至少执行一次步骤，再判断更新后的状态。两者不能同时出现。条件返回 `bool`，步骤必须使用更新块；更新块可包含局部 `const`、`if` 和 `switch`，不能 `return` 或写入 Store。

回调不能捕获外层变量，需要的数据放进初始状态。已有初值绑定仍可读取，状态更新不直接改写它。结果由外层新的 `const` 接收。`loop` 也可用于 RX 的 ZX 内联表达式；不提供 `forEach`。

生成的程序使用普通 Zig 循环，是否复用对象或列表存储由编译器的所有权与别名分析决定。完整语法及已验证边界见 [loop 使用参考](https://github.com/MatrixAges/zxc/blob/master/docs/2026-10-06/loop使用参考.md)。

### 继续传递更新后的列表

消耗式操作返回元组。将结果列表绑定到新名称，不需要的结果用 `_` 丢弃。

```typescript
export type Input = u64[]
export type Output = u64[]

export default function (in: Input): Output {
  const items = clone(in)
  const [with_item, _] = items.push(7)
  const [rest, removed] = with_item.pop()
  const [ordered, _] = rest.sort()
  const [reversed, _] = ordered.reverse()

  return reversed
}
```

消耗式操作之后，不要复用旧列表绑定。如果另一个分支还需要保留原值，应在所有权分开的地方克隆。

### 操作结果

| 操作                                 | 结果          | 约束                                              |
| ------------------------------------ | ------------- | ------------------------------------------------- |
| `push(item)`                         | `[T[], void]` | 消耗原列表                                        |
| `concat(items)`                      | `[T[], void]` | 产生更新后的列表                                  |
| `pop()`                              | `[T[], T?]`   | 被移除的值是可选值                                |
| `sort()`                             | `[T[], void]` | 仅数值或字符串元素；无比较器回调                  |
| `reverse()`                          | `[T[], void]` | 返回重排后的列表                                  |
| `splice(start, count, replacements)` | `[T[], T[]]`  | `start` 和 `count` 为 `u64`；第二个结果是被移除项 |

列表索引会检查边界，并可能失败。不要把越界访问当成返回可选值的查找方式。

分配的生命周期由宿主负责。返回列表不会把它的 arena 移交给垃圾收集器。继续阅读[宿主集成](/docs/host-integration)。
