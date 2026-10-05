const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, cli: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-process-stdio", "Validate standard stream boundaries and failure cleanup");

    for ([_][]const u8{ "read", "write" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/standard/resources/stdio/{s}.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "standard", .module = compiler.module("standard") }},
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/runtime/stdio/run_test.ts"));
    run.addFileInput(b.path("tests/runtime/stdio/fixture.ts"));
    run.addArtifactArg(cli.artifact("zxc"));
    run.addDirectoryArg(b.path("tests/runtime/stdio/fixtures"));
    run.addArg(@tagName(optimize));
    step.dependOn(&run.step);

    return step;
}
