const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, cli: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-rx-value-policy", "Reject RX inline calls while executing ZX logic through explicit Call nodes");

    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/rx/value_policy/analysis_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "rx", .module = compiler.module("rx") },
            .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
        },
    }) });

    tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
    step.dependOn(&b.addRunArtifact(tests).step);

    for ([_][]const u8{ "rejection", "runtime" }) |name| {
        const run = b.addSystemCommand(&.{"node"});

        run.addFileArg(b.path(b.fmt("tests/rx/value_policy/cli_{s}_test.ts", .{name})));
        run.addArtifactArg(cli.artifact("zxc"));
        run.addArg(@tagName(optimize));
        step.dependOn(&run.step);
    }

    return step;
}
