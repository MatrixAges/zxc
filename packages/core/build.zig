const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const backend = b.dependency("zxc_std", .{ .target = target, .optimize = optimize }).module("sha256_backend");

    _ = b.addModule("core", .{ .root_source_file = b.path("src/root.zig"), .target = target, .optimize = optimize, .imports = &.{.{ .name = "sha256_backend", .module = backend }} });
}
