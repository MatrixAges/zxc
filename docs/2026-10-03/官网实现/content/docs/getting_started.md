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
zig-out/bin/zxc packages/compiler/examples/quote.zx --out /tmp/quote.zig
zig-out/bin/zxc fmt packages/compiler/examples/quote.zx --check
```

Compilation emits Zig source. It does not run a complete RX service or automatically provision a runtime. Generated modules need the compiler's `zx_runtime` support module when integrated into a Zig host.

### Choose the boundary

Use ZX for computation. Use RX to describe composition. Confirm that your target host implements the RX execution and state behavior your application needs before promising a running service.
