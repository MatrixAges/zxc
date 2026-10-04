# <img src="images/logo.svg" alt="" height="28" align="absmiddle" /> zxc

**A business programming language built for AI collaboration: visible structure, independent logic.**

Describe business structure in **RX**, write atomic logic in **ZX**, compile to native programs.

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Experimental](https://img.shields.io/badge/status-experimental-orange.svg)
![Zig 0.16.0](https://img.shields.io/badge/zig-0.16.0-f7a41d.svg)

[Quick Start](#quick-start) · [Example](#a-complete-example) · [Status](#project-status) · [App Guide](packages/skills/README.md) · [RX Reference](packages/compiler/src/rx/README.md)

---

## What is zxc

zxc is a programming language and its compiler, made of two parts:

| Language | Form            | Responsibility                                                     |
| -------- | --------------- | ------------------------------------------------------------------ |
| **ZX**   | TypeScript-like | One file, one computation: declares `Input`, `Output` and rules    |
| **RX**   | XML             | Business structure: who calls whom, where data comes from and goes |

ZX is type- and ownership-checked, then compiled to Zig. RX composes these computation units into modules, and modules into larger business flows. `zxc build` embeds the Zig toolchain and produces executables directly.

## Why zxc

When AI writes and maintains a growing business system, the hard part is rarely a single function — it is the structure:

- **Structure is buried in code.** Call relations and data flow are scattered across function bodies. AI has to read large amounts of code to rebuild the big picture, and context grows fast.
- **Boundaries rely on discipline.** Responsibilities and dependency direction are only conventions; after a few rounds of edits, coupling and cycles creep in.
- **Impact of a change is hard to judge.** Change one rule, and it is unclear which upstream and downstream parts are affected.

zxc turns these conventions into language rules:

- **Structure as code** — an RX file _is_ the data-flow graph of the business. Follow each `Call`'s `in` / `out` to read the flow.
- **One unit, one responsibility** — every ZX file has exactly one default-exported function with typed input and output, so boundaries cannot silently erode.
- **Acyclic by construction** — the module dependency graph must be acyclic. The compiler enforces it, with no opt-out.
- **Fractal composition** — functions form modules, modules form larger modules, and every level follows the same rules.

The result: humans and AI can locate a change by reading only a few files, while the compiler guards the structure.

## A Complete Example

An order checkout: apply a discount, then waive shipping above a threshold.

**`quote.zx`** — atomic logic, concerned only with the computation:

```typescript
export type Input = {
  subtotal: u64
  discount: u64
  shipping_fee: u64
  free_shipping_minimum: u64
}

export type Output = {
  shipping: u64
  payable: u64
}

export default function (in: Input): Output {
  const discount = in.discount > in.subtotal ? in.subtotal : in.discount
  const discounted = in.subtotal - discount

  const shipping = match {
    discounted >= in.free_shipping_minimum => 0,
    _ => in.shipping_fee
  }

  return { shipping: shipping, payable: discounted + shipping }
}
```

**`checkout.rx`** — business structure, passes the input to the quote function and returns the result:

```xml
<Module>
  <Call fn="quote" in="$in" out="ctx.quote" />

  <Return value="ctx.quote" />
</Module>
```

**`order.rx`** — fractal composition, calls the whole checkout module as a service:

```xml
<Module>
  <Call service="checkout" in="$in" out="ctx.checkout" />

  <Return value="ctx.checkout" />
</Module>
```

Build and run:

```sh
zxc build order.rx --out build/order

./build/order '{"subtotal":12000,"discount":2000,"shipping_fee":600,"free_shipping_minimum":10000}'
# {"payable":10000,"shipping":0}
```

Module input and output types are inferred from `Call` and the ZX function signatures — no separate type files needed. When the free-shipping rule changes, only `quote.zx` is edited; `checkout.rx` and `order.rx` stay untouched.

## Features

**ZX language**

- TypeScript-like syntax with `const` only and no semicolons; `if`, `switch`, `match` expressions, destructuring and spread
- Explicit numeric types (`u64`, `i32`, `f32`, …), objects, enums, optionals, lists and tuples
- Ownership checking: no pointer syntax, no `clone`; the compiler decides how aggregates are passed and stored
- Capture-free `map` / `filter` / `reduce`
- Standard library: `std:encoding`, `std:crypto`, `std:path`, `std:querystring`, `std:zlib`, `std:os`
- Explicit, reviewed native interfaces via `zig:` / `c:`
- `requires` / `ensures` contracts with SMT verification over a bounded integer subset

**RX composition**

- `Call`, `Return`, `Task` and `Switch` build applications directly
- Module identity is the file path — no global names, no implicit lookup
- The entire dependency graph is required to be acyclic

**Toolchain**

- A single executable with the official Zig 0.16.0 embedded — users do not need to install Zig
- `zxc build` produces native programs, with `--target`, `--cpu`, `--optimize` and `--asm`
- Incremental rebuilds with `--watch`, formatting with `zxc fmt`
- Open IR and a `frontend` module for third-party backends

## Quick Start

zxc is currently built from source and requires [Zig 0.16.0](https://ziglang.org/download/):

```sh
git clone https://github.com/MatrixAges/zxc.git
cd zxc
zig build
```

The compiler is at `zig-out/bin/zxc`. Run the bundled example:

```sh
zig build zx-example
```

Put the three files from [the example above](#a-complete-example) in one directory and run `zxc build order.rx` to get an executable. See the [CLI docs](packages/cli/README.md) for more commands and options.

## Project Status

zxc is **experimental**. Both the language and the IR may change incompatibly; it is not yet recommended for production.

| Capability                                         | Status         |
| -------------------------------------------------- | -------------- |
| ZX parsing, type and ownership checks, Zig codegen | ✅ Available   |
| RX `Call` / `Return` / `Task` / `Switch`           | ✅ Available   |
| Acyclic dependency checks, `zxc build`, `--watch`  | ✅ Available   |
| `requires` / `ensures` contract verification       | 🧪 Partial     |
| Store state (runtime lifecycle)                    | 🚧 In progress |
| `Parallel` execution, events, Gateway              | 🚧 In progress |
| Dependency graph queries for AI                    | 🔭 Planned     |
| Formal proofs, FPGA and other hardware targets     | 🔭 Long term   |

See the [website docs](packages/website/content/docs/en/limits.md) for full capabilities and limits.

## Repository Layout

| Package                         | Description                                                 |
| ------------------------------- | ----------------------------------------------------------- |
| [`compiler`](packages/compiler) | RX / ZX frontend, type and ownership analysis, Zig backend  |
| [`cli`](packages/cli)           | The `zxc` executable: commands, builds, watch, distribution |
| [`core`](packages/core)         | IR data model                                               |
| [`genz`](packages/genz)         | Zig code generation                                         |
| [`dsl`](packages/dsl)           | Grammar definition framework                                |
| [`lint`](packages/lint)         | Naming and formatting rules                                 |
| [`pkgs`](packages/pkgs)         | Package management                                          |
| [`skills`](packages/skills)     | Guides for AI writing applications with zxc                 |
| [`test`](packages/test)         | Verification and regression                                 |
| [`website`](packages/website)   | Official website and docs                                   |

## Documentation

- **Using zxc:** [App Guide](packages/skills/README.md) · [CLI](packages/cli/README.md) · [RX Reference](packages/compiler/src/rx/README.md)
- **Language design:** [Design Doc](docs/zxc_deisgn_doc.md) · [Design Notes](docs/zxc_raw_thinking.md)
- **Contributing:** [Conventions](AGENTS.md) · [Compiler](packages/compiler/README.md) · [Verification](packages/test/README.md)

## License

[MIT](LICENSE) © 2026 MatrixAges
