const std = @import("std");

pub fn build(b: *std.Build) void {
    const compiler = b.dependency("compiler", .{});
    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("probe.zig"),
        .target = b.graph.host,
        .imports = &.{
            .{ .name = "compiler", .module = compiler.module("compiler") },
            .{ .name = "rx", .module = compiler.module("rx") },
            .{ .name = "analysis", .module = compiler.module("rx_analysis") },
        },
    }) });

    b.step("test", "Compare RX and ZX owned result consumption").dependOn(&b.addRunArtifact(tests).step);
}
