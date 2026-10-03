ZX assigns concrete types before generating Zig. It does not use JavaScript's single numeric type or implicit coercion rules.

### Choose a scalar

| Type                      | Intended value                        |
| ------------------------- | ------------------------------------- |
| `bool`                    | `true` or `false`                     |
| `u8`, `u16`, `u32`, `u64` | Unsigned integers of the stated width |
| `i32`, `i64`              | Signed integers                       |
| `f32`, `f64`              | Floating-point values                 |
| `string`                  | String data                           |
| `void`                    | No value                              |

Choose widths at boundaries deliberately. Existing integer variables do not implicitly widen, and integer variables do not implicitly become floats. Literals can take their type from context. Without a contextual type, positive integers default to `u64`, negative integers to `i64`, and decimal or exponent literals to `f64`.

### Shape structured data

```typescript
export type Input = {
  amount: u64;
  label: string?;
  adjustments: u64[];
};

export type Output = {
  amount: u64;
  label: string;
};

export default function (in: Input): Output {
  return { amount: in.amount, label: in.label ?? 'untitled' };
}
```

`T?` is an optional value; object properties also support the `name?: T` form. `T[]` is a list. `[T, U]` is a tuple. Objects, named types, and enums let the compiler check the shape of a boundary before execution.

### Check arithmetic assumptions

Integer division truncates toward zero. Remainders follow the dividend's sign. Invalid arithmetic is a runtime failure rather than a JavaScript-style coercion or an automatically recovered value. Validate business preconditions before performing operations that can fail.

`&&`, `||`, `??`, and conditional expressions short-circuit. String equality compares bytes. Do not assume structural deep equality for lists or objects.

### Keep names predictable

Use `snake_case` for values, `camelCase` for imported functions, and `PascalCase` for types. A default executable function is anonymous and its input parameter is named `in`.

Continue with [collections and ownership](/docs/collections-and-ownership).
