const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize });

    const executable = b.addExecutable(.{ .name = "ownership-observe", .root_module = b.createModule(.{
        .root_source_file = b.path("observe.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("frontend") }},
    }) });

    b.step("observe", "Observe ownership validation").dependOn(&b.addRunArtifact(executable).step);
}
