const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-library-initializers", "Validate Store initializer linkage codec compatibility import identity and resource cleanup");

    const store_fixture = b.createModule(.{
        .root_source_file = b.path("tests/library/store_fixture.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "compiler", .module = compiler.module("compiler") },
            .{ .name = "rx", .module = compiler.module("rx") },
            .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
        },
    });

    for ([_][]const u8{ "link", "codec", "imports" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/library/initializers/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "store_fixture", .module = store_fixture },
                .{ .name = "compiler", .module = compiler.module("compiler") },
                .{ .name = "rx", .module = compiler.module("rx") },
                .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
            },
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
