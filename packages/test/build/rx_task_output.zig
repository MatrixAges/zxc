const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, cli: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-rx-task-output", "Validate Task output expressions and target-derived Call results");

    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/rx/task_output/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "rx", .module = compiler.module("rx") },
            .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
            .{ .name = "compiler", .module = compiler.module("compiler") },
        },
    }) });

    tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    step.dependOn(&b.addRunArtifact(tests).step);

    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/rx/task_output/cli_test.ts"));
    run.addFileInput(b.path("tests/rx/task_output/cli_fixture.ts"));
    run.addFileInput(b.path("tests/rx/task_output/cases.json"));
    run.addDirectoryArg(b.path("tests/rx/task_output/fixtures"));
    run.addArtifactArg(cli.artifact("zxc"));
    run.addArg(@tagName(optimize));
    step.dependOn(&run.step);

    return step;
}
