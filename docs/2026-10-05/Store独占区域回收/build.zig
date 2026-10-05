const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const compiler = b.dependency("compiler", .{ .target = target });

    const executable = b.addExecutable(.{ .name = "store-model", .root_module = b.createModule(.{
        .root_source_file = b.path("generate.zig"),
        .target = target,
        .imports = &.{
            .{ .name = "compiler", .module = compiler.module("compiler") },
            .{ .name = "rx", .module = compiler.module("rx") },
            .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
        },
    }) });

    b.installArtifact(executable);
}
