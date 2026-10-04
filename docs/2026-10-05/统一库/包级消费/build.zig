const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const library = b.dependency("library", .{ .target = target, .optimize = optimize });

    const executable = b.addExecutable(.{
        .name = "consume",
        .root_module = b.createModule(.{
            .root_source_file = b.path("main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "choose", .module = library.module("choose") },
                .{ .name = "read", .module = library.module("read") },
            },
        }),
    });

    b.installArtifact(executable);
}
