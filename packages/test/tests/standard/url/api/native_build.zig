const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const library = b.dependency("library", .{ .target = target, .optimize = optimize });
    const support = b.createModule(.{ .root_source_file = b.path("support.zig"), .target = target, .optimize = optimize });

    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("cases.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "program", .module = library.module("library") }, .{ .name = "support", .module = support } },
    }) });

    b.default_step.dependOn(&b.addRunArtifact(tests).step);
}
