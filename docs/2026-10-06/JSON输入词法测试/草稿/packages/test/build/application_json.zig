const std = @import("std");
const Suite = @import("catalog.zig").RuntimeSuite;

pub fn add(b: *std.Build, cli: *std.Build.Dependency, optimize: std.builtin.OptimizeMode, suite: Suite) *std.Build.Step {
    const run = b.addSystemCommand(&.{"node"});
    const directory = "tests/targets/application_json";

    run.addFileArg(b.path(directory ++ "/run_test.ts"));

    for ([_][]const u8{ "model.ts", "fixture.ts", "check.ts" }) |name| {
        run.addFileInput(b.path(b.fmt("{s}/{s}", .{ directory, name })));
    }

    run.addFileInput(b.path("src/shared/json.ts"));
    run.addFileInput(b.path("tests/targets/wasm/host.ts"));
    run.addFileInput(b.path("tests/targets/wasm/wasi_host.ts"));
    run.addArtifactArg(cli.artifact("zxc"));
    run.addFileArg(b.path(b.fmt("tests/{s}.zx", .{suite.path})));
    run.addFileArg(b.path(b.fmt("tests/{s}.jsonl", .{suite.path})));
    run.addArg(@tagName(optimize));

    _ = run.addOutputFileArg(b.fmt("{s}-{t}.json", .{ suite.name, optimize }));
    run.has_side_effects = true;

    return &run.step;
}
