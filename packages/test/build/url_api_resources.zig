const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-url-api-resources", "Validate public URL record ownership and allocation failure propagation");

    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/standard/resources/url/api/record_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "implementation", .module = compiler.module("standard") }},
    }) });

    step.dependOn(&b.addRunArtifact(tests).step);

    return step;
}
