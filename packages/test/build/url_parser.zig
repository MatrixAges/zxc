const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-url-parser", "Validate complete pinned WPT URL parsing and serialization corpus");

    for (0..9) |group| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/standard/resources/url/parser/group_{d}_test.zig", .{group})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "implementation", .module = compiler.module("standard") }},
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
