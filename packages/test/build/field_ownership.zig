const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-field-ownership", "Validate static ownership paths and overlapping borrow boundaries");

    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/ownership/fields/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    step.dependOn(&b.addRunArtifact(tests).step);

    return step;
}
