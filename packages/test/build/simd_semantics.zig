const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-simd-semantics", "Execute floating-point SIMD tails scalar fallbacks and WASM targets");
    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/targets/simd/run_test.ts"));

    for ([_][]const u8{ "simd/assembly.ts", "simd/check.ts", "simd/expected.ts", "simd/values.ts", "napi/load.ts", "wasm/host.ts" }) |name| {
        run.addFileInput(b.path(b.fmt("tests/targets/{s}", .{name})));
    }

    run.addArtifactArg(cli.artifact("zxc"));
    run.addDirectoryArg(b.path("tests/targets/simd/fixtures"));
    run.addArg(@tagName(optimize));
    step.dependOn(&run.step);

    return step;
}
