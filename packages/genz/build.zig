const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const module = b.addModule("genz", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zx", .module = b.dependency("zx", .{ .target = target, .optimize = optimize }).module("zx") }},
    });

    const library = b.addLibrary(.{ .name = "zxc_genz", .root_module = module });

    b.installArtifact(library);
}
