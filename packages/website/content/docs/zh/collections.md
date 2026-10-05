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

### 顺序执行，不收集结果

```typescript
items.forEach(item => processItem(item))
```

`forEach` 按列表索引顺序执行单参数、无捕获的表达式回调，返回 `void`。回调结果逐轮丢弃，不创建结果列表；空列表不调用回调。它直接编译为 Zig 循环与静态调用，副作用不会被并行化。

元素保持借用语义，不能在回调中消费借用元素或修改正在遍历的列表。回调失败时立即停止，不执行后续元素，也不回滚已经发生的外部副作用。`forEach` 可以独立作为语句；其他独立调用也必须返回 `void`。

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
