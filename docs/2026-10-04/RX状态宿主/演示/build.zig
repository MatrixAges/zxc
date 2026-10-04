const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const runtime = b.dependency("runtime", .{ .target = target, .optimize = optimize });

    const executable = b.addExecutable(.{
        .name = "store-lifetime",
        .root_module = b.createModule(.{
            .root_source_file = b.path("main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "runtime", .module = runtime.module("runtime") }},
        }),
    });

    b.installArtifact(executable);
}
