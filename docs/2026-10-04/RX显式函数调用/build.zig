const std = @import("std");

pub fn build(b: *std.Build) void {
    const compiler = b.dependency("compiler", .{});

    const executable = b.addExecutable(.{ .name = "inspect-rx-module", .root_module = b.createModule(.{
        .root_source_file = b.path("inspect.zig"),
        .target = b.graph.host,
        .imports = &.{
            .{ .name = "frontend", .module = compiler.module("frontend") },
            .{ .name = "rx", .module = compiler.module("rx") },
            .{ .name = "analysis", .module = compiler.module("rx_analysis") },
        },
    }) });

    b.installArtifact(executable);
}
