const std = @import("std");

pub fn build(b: *std.Build) void {
    const compiler = b.dependency("compiler", .{});

    const executable = b.addExecutable(.{ .name = "inspect-rx-order", .root_module = b.createModule(.{
        .root_source_file = b.path("inspect_order.zig"),
        .target = b.graph.host,
        .imports = &.{.{ .name = "rx", .module = compiler.module("rx") }},
    }) });

    b.installArtifact(executable);
}
