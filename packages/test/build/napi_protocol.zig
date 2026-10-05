const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-napi-protocol", "Execute Node addon scalar collection exception and Worker contracts");
    const run = b.addSystemCommand(&.{ "node", "--expose-gc" });

    run.addFileArg(b.path("tests/targets/napi/run_test.ts"));

    for ([_][]const u8{ "load.ts", "scalars.ts", "bytes.ts", "records.ts", "properties.ts", "collections.ts", "state.ts", "worker.ts" }) |name| {
        run.addFileInput(b.path(b.fmt("tests/targets/napi/{s}", .{name})));
    }

    run.addArtifactArg(cli.artifact("zxc"));
    run.addDirectoryArg(b.path("tests/targets/napi/fixtures"));
    run.addArg(@tagName(optimize));
    step.dependOn(&run.step);

    return step;
}
