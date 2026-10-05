const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize }).module("compiler");

    const check = b.createModule(.{
        .root_source_file = b.path("../../../packages/test/tests/ownership/fields/check.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler }},
    });

    const executable = b.addExecutable(.{ .name = "observe", .root_module = b.createModule(.{
        .root_source_file = b.path("observe.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "check", .module = check }},
    }) });

    b.installArtifact(executable);
}
