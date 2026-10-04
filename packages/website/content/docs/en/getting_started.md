### Obtain the compiler

The current documented setup builds from source. Install Zig **0.16.0** for this revision, then:

```sh
git clone https://github.com/MatrixAges/zxc.git
cd zxc
zig build
zig build zx-example
```

`zx-example` compiles and runs the repository's real ZX example. These are source-checkout commands; an application's host may provide a different build entry point.

### Compile a ZX file

From the source checkout:

```sh
zig-out/bin/zxc packages/cli/examples/quote.zx --out /tmp/quote.zig
zig-out/bin/zxc fmt packages/cli/examples/quote.zx --check
```

Compilation emits Zig source. It does not run a complete RX service or automatically provision a runtime. Generated modules need the compiler's `zx_runtime` support module when integrated into a Zig host.

### Choose the boundary

Use ZX for computation. Use RX to describe composition. Confirm that your target host implements the RX execution and state behavior your application needs before promising a running service.

### Read a complete computation

The repository's `quote.zx` example has an explicit price, discount, enable flag, and floating-point factor:

```typescript
export type Input = {
  amount: u64;
  discount: u64;
  enabled: bool;
  factor: f32;
};

export type Output = {
  amount: u64;
  factor: f32;
};

export default function (in: Input): Output {
  const adjusted_factor = in.factor * 0.5;

  if (!in.enabled || in.discount > in.amount) {
    return { amount: in.amount, factor: adjusted_factor };
  }

  return { amount: in.amount - in.discount, factor: adjusted_factor };
}
```

The guard prevents an unsigned subtraction when the discount exceeds the amount. The calculation halves the factor on both branches. For an enabled input with amount `100`, discount `15`, and factor `2.0`, the expected result is amount `85` and factor `1.0`.

This is an expected result derived from the source. To verify execution in your environment, use the repository's executable example or wire the generated module into your own host with the input above.

### Finish the first milestone

You should now have a compiler binary, generated Zig source, and a working repository example. Keep these three outcomes separate: formatting checks source presentation, compilation checks the program, and host execution runs the generated output.

Continue with [write logic](/docs/write-logic), then [Zig host integration](/docs/host-integration).
