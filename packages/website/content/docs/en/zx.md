### Explicit input and output

ZX is TypeScript-like, not JavaScript. Declare the input and output types and export a default function. This minimal computation preserves its input amount:

```typescript
export type Input = {
  amount: u64;
};

export type Output = {
  amount: u64;
};

export default function (in: Input): Output {
  return { amount: in.amount };
}
```

### Keep computation bounded

The current compiler supports scalar values, objects, enums, optional values, lists, tuples, local bindings, branches, and file imports. Collection operations include non-capturing `map`, `filter`, and `reduce`.

Do not assume arbitrary closures, general loops, JavaScript coercion, or runtime capability imports are supported. Numeric types have explicit semantics; do not rely on JavaScript number behavior.

### Make ownership explicit

Use `clone` when deep copying is required. Store access is provided through declared handles with independent read and write permissions. Host code owns lifetime, persistence, and commit behavior.

Use the installed toolchain's formatter and diagnostics. Confirm exact contracts in the [compiler reference](https://github.com/MatrixAges/zxc/blob/master/packages/compiler/README.md).

### Put shared contracts in a type-only file

When two executable files share a data shape, export that shape from a separate type-only `.zx` file. Keep executable imports and shared-type imports distinct. This prevents a computation's private input shape from becoming an accidental shared API.

### Return on every required path

A non-void output needs a value along each possible path. Prefer a guard for invalid business conditions and a clear result after the guard. A compiler `return_path` diagnostic means the declared output and the control flow do not agree.

### Choose the next guide

- [Types and values](/docs/types-and-values): scalar widths, optionals, and structured data.
- [Collections and ownership](/docs/collections-and-ownership): transforms and consuming operations.
- [Paths and imports](/docs/module-paths): shared types and executable dependencies.
- [ZX reference](/docs/zx-reference): supported syntax and unsupported assumptions.
