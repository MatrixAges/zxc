const std = @import("std");

pub fn create(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Module {
    const abi = b.createModule(.{ .root_source_file = b.path("bootstrap/constants/types.zig"), .target = target, .optimize = optimize });

    const standard = b.createModule(.{
        .root_source_file = b.dependency("zxc_std", .{}).path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zxc_abi", .module = abi }},
    });

    const generated = b.createModule(.{
        .root_source_file = b.path("bootstrap/constants/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "zxc_standard", .module = standard } },
    });

    return b.createModule(.{
        .root_source_file = b.path("bootstrap/constants/constant_fold.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "generated", .module = generated }},
    });
}
