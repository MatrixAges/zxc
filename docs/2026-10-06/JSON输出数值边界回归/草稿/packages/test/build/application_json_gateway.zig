const std = @import("std");
const Suite = @import("catalog.zig").RuntimeSuite;

pub fn add(b: *std.Build, cli: *std.Build.Dependency, optimize: std.builtin.OptimizeMode, suites: []const Suite) *std.Build.Step {
    const step = b.step("test-application-json-gateway", "Execute shared JSON output cases through HTTP Gateway services");
    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/targets/application_json/gateway/run_test.ts"));
    run.addFileInput(b.path("tests/targets/application_json/model.ts"));
    run.addFileInput(b.path("tests/runtime/gateway/application.ts"));
    run.addFileInput(b.path("tests/runtime/gateway/request.ts"));
    run.addFileInput(b.path("src/shared/json.ts"));

    for (suites) |suite| {
        if (!std.mem.startsWith(u8, suite.name, "application-json-output-")) continue;

        run.addFileInput(b.path(b.fmt("tests/{s}.zx", .{suite.path})));
        run.addFileInput(b.path(b.fmt("tests/{s}.jsonl", .{suite.path})));
    }

    run.addArtifactArg(cli.artifact("zxc"));
    run.addFileArg(b.path("suites.json"));
    run.addArg(@tagName(optimize));

    _ = run.addOutputFileArg(b.fmt("application-json-gateway-{t}.json", .{optimize}));
    run.has_side_effects = true;

    step.dependOn(&run.step);

    return step;
}
