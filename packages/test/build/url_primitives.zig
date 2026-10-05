const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-url-primitives", "Validate URL byte encoding and IP parsing normalization");

    for ([_][]const u8{ "percent", "host/ipv4", "host/ipv6" }) |name| {
        const implementation = b.createModule(.{
            .root_source_file = compiler.path(b.fmt("standard/src/url/{s}.zig", .{name})),
            .target = target,
            .optimize = optimize,
        });

        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/standard/resources/url/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "implementation", .module = implementation }},
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
