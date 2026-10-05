const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    _ = b.addModule("napi", .{ .root_source_file = b.path("src/root.zig"), .target = target, .optimize = optimize });
    _ = b.addModule("resources", .{ .root_source_file = b.path("src/resources.zig"), .target = target, .optimize = optimize });

    _ = b.addModule("declarations", .{
        .root_source_file = b.path("src/declarations.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zx", .module = b.dependency("core", .{ .target = target, .optimize = optimize }).module("core") }},
    });
}
