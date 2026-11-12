const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const standard = b.dependency("zxc_std", .{ .target = target, .optimize = optimize });

    _ = b.addModule("core", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "sha256_backend", .module = standard.module("sha256_backend") },
            .{ .name = "bytes_backend", .module = standard.module("bytes_backend") },
        },
    });
}
