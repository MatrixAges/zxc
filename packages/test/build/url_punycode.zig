const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-url-punycode", "Validate RFC3492 encoding decoding invalid inputs and resource cleanup");

    const implementation = b.createModule(.{
        .root_source_file = compiler.path("standard/src/url/host/idna/punycode.zig"),
        .target = target,
        .optimize = optimize,
    });

    for ([_][]const u8{ "rfc", "boundary", "properties", "rejection", "allocation" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/standard/resources/url/idna/punycode/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "implementation", .module = implementation }},
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
