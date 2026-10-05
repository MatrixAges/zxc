const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-wasm-protocol", "Execute WebAssembly scalar JSON state lifecycle and WASI contracts");
    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/targets/wasm/run_test.ts"));

    for ([_][]const u8{ "host.ts", "protocol.ts", "scalars.ts", "state.ts", "wasi_host.ts" }) |name| {
        run.addFileInput(b.path(b.fmt("tests/targets/wasm/{s}", .{name})));
    }

    run.addArtifactArg(cli.artifact("zxc"));
    run.addDirectoryArg(b.path("tests/targets/wasm/fixtures"));
    run.addArg(@tagName(optimize));
    step.dependOn(&run.step);

    return step;
}
