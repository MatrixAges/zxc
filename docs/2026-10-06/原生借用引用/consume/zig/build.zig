const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize });
    const published = b.dependency("published", .{ .target = target, .optimize = optimize });

    const executable = b.addExecutable(.{ .name = "walk", .root_module = b.createModule(.{
        .root_source_file = b.path("../../run.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "rx", .module = compiler.module("rx") }, .{ .name = "walk", .module = published.module("library") } },
    }) });

    b.installArtifact(executable);
}
