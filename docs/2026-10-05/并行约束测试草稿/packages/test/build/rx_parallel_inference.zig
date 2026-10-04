const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-rx-parallel-inference", "Validate RX parallel binding and capability boundaries");

    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/rx/inference/parallel/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "rx", .module = compiler.module("rx") },
                .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
                .{ .name = "compiler", .module = compiler.module("compiler") },
            },
        }),
    });

    step.dependOn(&b.addRunArtifact(tests).step);

    return step;
}
