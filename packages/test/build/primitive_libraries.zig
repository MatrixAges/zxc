const std = @import("std");

pub fn add(b: *std.Build, cli: *std.Build.Dependency, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-primitive-libraries", "Execute identical primitive catalogs through source and compiled public packages");
    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/library/primitives/run.ts"));

    for ([_][]const u8{ "catalog", "command", "package" }) |name| run.addFileInput(b.path(b.fmt("tests/library/primitives/{s}.ts", .{name})));
    for ([_][]const u8{ "src/emit_floating_tests.ts", "src/emit_control_tests.ts", "src/shared/json.ts", "src/shared/zig_literal.ts", "src/zig_string.ts" }) |path| run.addFileInput(b.path(path));

    run.addArtifactArg(cli.artifact("zxc"));
    run.addArg(b.graph.zig_exe);
    run.addArg(@tagName(optimize));
    run.addFileArg(b.path("suites.json"));
    run.addDirectoryArg(b.path("tests"));

    _ = run.addOutputDirectoryArg("primitive-libraries");
    run.has_side_effects = true;

    step.dependOn(&run.step);

    return step;
}
