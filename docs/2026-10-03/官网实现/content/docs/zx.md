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
