### Why TypeScript-like syntax

Atomic logic needs calculations, conditions, and data transformations. Functions, objects, type annotations, and expressions are familiar to TypeScript users. Reusing that surface syntax aims to lower the learning, reading, and generation cost for people and AI, keeping attention on business rules and input/output contracts.

ZX constrains both grammar and semantics: explicit numeric widths, checkable ownership, and controlled capability boundaries let the compiler analyze programs statically and generate Zig. Familiar notation combined with constrained execution semantics provides a foundation for verifying and optimizing atomic units.

TypeScript-like does not mean full TypeScript compatibility. ZX does not depend on the TypeScript compiler or a JavaScript runtime, and arbitrary TypeScript code or npm packages cannot be assumed to work. Its performance potential comes from static semantics and compilation, not surface syntax.

### Explicit input and output

ZX is TypeScript-like, not JavaScript. Declare the input and output types and export a default function. This minimal computation preserves its input amount:

```typescript
export type Input = {
  amount: u64
}

export type Output = {
  amount: u64
}

export default function (in: Input): Output {
  return { amount: in.amount }
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

### Write independently understandable units

A ZX atom gives one computation a clear input/output contract: a price calculation, eligibility decision, or data transformation, for example. RX composes these units. Atomicity here describes responsibility, not a transaction guarantee, and does not require a separate file for each expression.

Explicit types, ownership, and side-effect boundaries create conditions for local verification and operator-style optimization. The current path is ZX → typed IR → Zig. Inlining, specialization, and abstraction elimination must be checked against the backend, generated code, and measurements. Formal proofs and FPGA targets require future toolchain work; small units alone do not provide them.

### match expressions

The match expression has two forms: `match { ... }` selects a result using complete boolean conditions; `match value { ... }` selects by a target value. The expression after `=>` is the result, and `_` is the default branch.

```typescript
const shipping = match {
  discounted >= in.free_shipping_minimum => 0,
  _ => in.shipping_fee
}

const label = match status {
  "paid" => "ready",
  "pending" => "waiting",
  _ => "blocked"
}
```

Conditions are checked in source order and only the selected result is evaluated. In value mode, the target is evaluated once and must be a non-void scalar or enum. A single final `_` branch is required; trailing commas are allowed. Result types must agree. Use `&&` for conjunction. Ranges, destructuring, and chained comparisons are unsupported.
