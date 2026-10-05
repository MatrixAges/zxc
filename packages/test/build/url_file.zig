const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-url-file", "Validate explicit platform file URL conversions and allocation cleanup");

    for ([_][]const u8{ "from_path", "to_path", "to_bytes" }) |operation| {
        for ([_][]const u8{ "posix", "windows" }) |platform| {
            const tests = b.addTest(.{ .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/standard/resources/url/file/{s}_{s}_test.zig", .{ operation, platform })),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "implementation", .module = compiler.module("standard") }},
            }) });

            step.dependOn(&b.addRunArtifact(tests).step);
        }
    }

    const invalid = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/standard/resources/url/file/invalid_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "implementation", .module = compiler.module("standard") }},
    }) });

    step.dependOn(&b.addRunArtifact(invalid).step);

    return step;
}
