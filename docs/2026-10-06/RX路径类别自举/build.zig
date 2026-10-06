const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize });

    const native = b.createModule(.{
        .root_source_file = b.path("../../../../zxc_zig/packages/compiler/src/rx/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "dsl", .module = b.dependency("dsl", .{ .target = target, .optimize = optimize }).module("dsl") },
            .{ .name = "frontend", .module = compiler.module("frontend") },
        },
    });

    const executable = b.addExecutable(.{ .name = "path-reference", .root_module = b.createModule(.{
        .root_source_file = b.path("path_reference.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "rx", .module = compiler.module("rx") },
            .{ .name = "native", .module = native },
        },
    }) });

    b.installArtifact(executable);
}
