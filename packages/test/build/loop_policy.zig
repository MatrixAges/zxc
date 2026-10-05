const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, cli: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-loop-policy", "Reject retired iteration APIs while preserving loop imports and independent void calls");

    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/language/expressions/loop_policy/analysis_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    step.dependOn(&b.addRunArtifact(tests).step);

    const run = b.addSystemCommand(&.{"node"});

    run.addFileArg(b.path("tests/language/expressions/loop_policy/cli_test.ts"));
    run.addArtifactArg(cli.artifact("zxc"));
    run.addArg(@tagName(optimize));
    step.dependOn(&run.step);

    return step;
}
