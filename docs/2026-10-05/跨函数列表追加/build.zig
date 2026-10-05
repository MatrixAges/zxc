const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize });
    const genz = b.dependency("genz", .{ .target = target, .optimize = optimize });

    const executable = b.addExecutable(.{ .name = "list-flow-observe", .root_module = b.createModule(.{
        .root_source_file = b.path("observe.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "compiler", .module = compiler.module("frontend") },
            .{ .name = "genz", .module = genz.module("genz") },
        },
    }) });

    b.installArtifact(executable);
}
