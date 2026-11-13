const std = @import("std");

pub fn module(b: *std.Build, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, source: std.Build.LazyPath, strip: ?bool) *std.Build.Module {
    return b.createModule(.{
        .root_source_file = b.path("src/zx/frontend/lex.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") },
            .{ .name = "generated", .module = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize, .strip = strip }) },
        },
    });
}
