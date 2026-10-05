const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency) *std.Build.Step {
    const step = b.step("test-semantic-lint", "Validate semantic lint scope diagnostics and read-only behavior");

    for ([_][]const u8{ "project", "options", "rx", "workspace", "compiled" }) |name| {
        const run = b.addSystemCommand(&.{"node"});

        run.addFileArg(b.path(b.fmt("tests/semantic_lint/{s}_test.ts", .{name})));
        run.addFileInput(b.path("tests/semantic_lint/fixture.ts"));

        if (std.mem.eql(u8, name, "rx")) run.addFileInput(b.path("tests/semantic_lint/rx_cases.ts"));
        if (std.mem.eql(u8, name, "workspace")) run.addFileInput(b.path("tests/semantic_lint/workspace_cases.ts"));
        if (std.mem.eql(u8, name, "compiled")) run.addFileInput(b.path("tests/semantic_lint/compiled_fixture.ts"));

        run.addArtifactArg(cli.artifact("zxc"));
        step.dependOn(&run.step);
    }

    return step;
}
