ZX makes list transformations and ownership visible. Treat an input collection as borrowed data. Clone it when you need an owned value for a consuming operation.

### Transform without a general loop

```typescript
export type Input = u64[][]
export type Output = u64[]

export default function (in: Input): Output {
  return in.map((row) => row.filter((item) => item > 2).reduce((sum, item) => sum + item, 0))
}
```

`map` and `filter` take a one-argument callback. `reduce` takes a two-argument callback and an explicit initial accumulator. Callbacks have expression bodies and cannot capture outer values or Store handles. They may call imported functions.

### Repeat according to state

`loop` takes an initial state and inline rules, then returns the final state of the same type. `while` checks the state first; `next` produces the next state when the condition is true.

```typescript
const result = loop(initial, {
	while: state => state.remaining > 0,
	next: state => {
		state.remaining -= 1
		state.processed += 1
	}
})
```

Use `do` instead of `next` to run the step at least once and check the updated state afterward. The rules cannot contain both. The condition returns `bool`; the step must be an update block. It may contain local `const` bindings, `if`, and `switch`, but cannot return early or write to Store.

Callbacks cannot capture outer variables. Include required data in the initial state. An existing initial-state binding remains readable; the update does not mutate it. Bind the result to a new outer `const`. The same operation works in RX inline ZX expressions. There is no `forEach` operation.

The compiler emits ordinary Zig loops. Storage reuse depends on ownership and alias analysis; using `loop` does not guarantee that every application operation avoids allocation. See the [loop reference](https://github.com/MatrixAges/zxc/blob/master/docs/2026-10-06/loop使用参考.md) for syntax and verified boundaries.

### Carry the updated list forward

Consuming operations return a tuple. Bind the resulting list to a new name and discard an unneeded result with `_`.

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

After a consuming operation, do not reuse the old list binding. If you must preserve the original value for another branch, clone it at the point where ownership separates.

### Operation results

| Operation                            | Result        | Constraint                                                          |
| ------------------------------------ | ------------- | ------------------------------------------------------------------- |
| `push(item)`                         | `[T[], void]` | Consumes the original list                                          |
| `concat(items)`                      | `[T[], void]` | Produces the updated list                                           |
| `pop()`                              | `[T[], T?]`   | Removed value is optional                                           |
| `sort()`                             | `[T[], void]` | Numeric or string elements; no comparator callback                  |
| `reverse()`                          | `[T[], void]` | Returns the reordered list                                          |
| `splice(start, count, replacements)` | `[T[], T[]]`  | `start` and `count` are `u64`; second result contains removed items |

List indexing is bounds checked and can fail. Do not use an out-of-range access as an optional-value lookup.

The host owns allocation lifetime. Returning a list does not transfer its arena into a garbage collector. Continue with [host integration](/docs/host-integration).
