ZX makes list transformations and ownership visible. Treat an input collection as borrowed data. Clone it when you need an owned value for a consuming operation.

### Transform without a general loop

```typescript
export type Input = u64[][]
export type Output = u64[]

export default function (in: Input): Output {
  return in.map((row) => row.filter((item) => item > 2).reduce((sum, item) => sum + item, 0))
}
```

`map`, `filter`, `every`, and `some` pass `(value, index, array)` to their callback. `reduce` passes `(accumulator, value, index, array)`. Declare only the parameter prefix you need. Indices are `u64`; filter reports positions in the input array.

Callbacks can read outer bindings by lexical capture. The compiler carries the referenced values into an ordinary Zig loop without allocating a dynamic closure. Reference data remains borrowed. Callbacks have expression bodies, may call imported functions, and cannot capture Task handles or access Store.

The initial accumulator for `reduce` is optional. Without it, the first element seeds the result and callbacks begin at the second element; an empty array returns `IndexOutOfBounds`. `every` and `some` short-circuit, returning `true` and `false` respectively for an empty array. A non-reduce method's optional second argument is evaluated once in order, but does not supply context to an arrow callback; refer to outer bindings directly.

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

The rule callbacks of `loop` still use explicit state. Include required data in the initial state. An existing initial-state binding remains readable; the update does not mutate it. Bind the result to a new outer `const`. RX must use `Call.fn` to invoke the ZX module containing `loop`; function and method calls are not allowed inside RX attribute values. There is no `forEach` operation.

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
