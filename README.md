# <img src="images/logo.svg" alt="" height="28" align="absmiddle" /> zxc

**A programming language for AI-written business systems.** Write logic in **ZX** (TypeScript-like), wire it together in **RX** (XML), and compile to a native executable.

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Experimental](https://img.shields.io/badge/status-experimental-orange.svg)
![Zig 0.16.0](https://img.shields.io/badge/zig-0.16.0-f7a41d.svg)

[Quick Start](#quick-start) · [CLI](packages/cli/README.md) · [RX Reference](packages/compiler/src/rx/README.md) · [Compiler](packages/compiler/README.md) · [Design](docs/zxc_deisgn_doc.md)

## Example

A checkout flow. **RX** is the map — every step, and what flows between them, in one file:

```xml
<!-- checkout.rx -->
<Module>
  <Call fn="subtotal" in="$in.items" out="ctx.subtotal" />
  <Call fn="discount" in="{subtotal:ctx.subtotal,coupon:$in.coupon}" out="ctx.discounted" />
  <Call fn="shipping" in="{amount:ctx.discounted,region:$in.region}" out="ctx.shipping" />
  <Call fn="total" in="{amount:ctx.discounted,shipping:ctx.shipping}" out="ctx.total" />

  <Return value="ctx.total" />
</Module>
```

**ZX** holds the logic — each step is one typed function in its own file:

```typescript
// shipping.zx
export type Input = {
  amount: u64
  region: string
}

export type Output = u64

export default function (in: Input): Output {
  return match {
    in.amount >= 10000 => 0,
    in.region == "remote" => 1500,
    _ => 600
  }
}
```

Build it into a native executable and run it:

```sh
zxc build checkout.rx --out build/checkout

./build/checkout '{"items":[{"price":4500,"quantity":2},{"price":3000,"quantity":1}],"coupon":"SAVE10","region":"remote"}'
# {"payable":10800,"shipping":0}
```

To change the shipping rule, an AI only needs `shipping.zx` — `checkout.rx` already tells it what goes in and what comes out. The compiler infers types across every `Call`, so a mismatched edit fails at build time, not in production.

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
