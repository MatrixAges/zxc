const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-standard-fs", "Validate filesystem operations, limits, path rejection and allocation cleanup");

    for ([_][]const u8{ "read", "write", "directories", "paths", "metadata", "validation", "allocation" }) |name| {
        const tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/standard/resources/fs/{s}_test.zig", .{name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "standard", .module = compiler.module("standard") }},
            }),
        });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
