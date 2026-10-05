const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-napi-bindings", "Validate Node module declarations loading and publication protection");
    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/targets/napi_bindings/run_test.ts"));

    for ([_][]const u8{ "typecheck.ts", "publication.ts" }) |name| {
        run.addFileInput(b.path(b.fmt("tests/targets/napi_bindings/{s}", .{name})));
    }

    for ([_][]const u8{ "load.ts", "input.ts", "protocol.ts", "ownership.ts", "state.ts", "lifecycle.ts", "worker.ts", "errors.ts", "run_test.ts" }) |name| {
        run.addFileInput(b.path(b.fmt("tests/targets/napi/async/{s}", .{name})));
    }

    run.addArtifactArg(cli.artifact("zxc"));
    run.addDirectoryArg(b.path("tests/targets/napi/fixtures"));
    run.addFileArg(b.path("tests/targets/napi_bindings/fixtures/consumer.mts"));
    run.addFileInput(b.path("tests/targets/napi_bindings/fixtures/no_input.zx"));
    run.addFileInput(b.path("tests/targets/napi_bindings/fixtures/no_output.zx"));
    run.addArg(@tagName(optimize));
    step.dependOn(&run.step);

    return step;
}
