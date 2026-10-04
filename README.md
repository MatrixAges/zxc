# <img src="images/logo.svg" alt="" height="28" align="absmiddle" /> zxc

**A programming language for AI-written business systems.** Write logic in **ZX** (TypeScript-like), wire it together in **RX** (XML), and compile to a native executable.

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Experimental](https://img.shields.io/badge/status-experimental-orange.svg)
![Zig 0.16.0](https://img.shields.io/badge/zig-0.16.0-f7a41d.svg)

[Quick Start](#quick-start) · [CLI](packages/cli/README.md) · [RX Reference](packages/compiler/src/rx/README.md) · [Compiler](packages/compiler/README.md) · [Design](docs/zxc_deisgn_doc.md)

## At a Glance

**`quote.zx`** — one file, one typed computation:

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

**`checkout.rx`** — the data flow, visible as structure:

```xml
<Module>
  <Call fn="quote" in="$in" out="ctx.quote" />

  <Return value="ctx.quote" />
</Module>
```

**Build and run:**

```sh
zxc build checkout.rx --out build/checkout

./build/checkout '{"subtotal":12000,"discount":2000,"shipping_fee":600,"free_shipping_minimum":10000}'
# {"payable":10000,"shipping":0}
```

Modules compose the same way: another RX file can `<Call service="checkout" />` and treat the whole module as a single unit.

## Why zxc

- **Structure you can read** — RX files are the call graph and data flow. No digging through function bodies.
- **Boundaries the compiler enforces** — typed `Input` / `Output` per unit, ownership checks, and a dependency graph that must be acyclic.
- **Small, local changes** — change a rule in one `.zx` file; the RX wiring stays untouched.
- **Native output** — ZX compiles to Zig, and `zxc build` ships with an embedded Zig toolchain.

## Quick Start

Requires [Zig 0.16.0](https://ziglang.org/download/) to build from source:

```sh
git clone https://github.com/MatrixAges/zxc.git
cd zxc
zig build
```

The compiler is at `zig-out/bin/zxc`. See the [CLI docs](packages/cli/README.md) for commands and options.

## Status

zxc is **experimental**; the language and IR may change. ZX compilation and RX `Call` / `Return` / `Task` / `Switch` work today. Store state, `Parallel`, events and Gateway are in progress. See [capabilities and limits](packages/website/content/docs/en/limits.md).

## License

[MIT](LICENSE)
