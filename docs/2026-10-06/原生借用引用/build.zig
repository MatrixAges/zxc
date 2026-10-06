const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize });
    const dsl = b.dependency("dsl", .{ .target = target, .optimize = optimize });

    const generator = b.addExecutable(.{ .name = "generate-walk", .root_module = b.createModule(.{
        .root_source_file = b.path("generate.zig"),
        .target = b.graph.host,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    const generate = b.addRunArtifact(generator);
    const source = generate.addOutputFileArg("walk.zig");
    const types = generate.addOutputFileArg("abi.zig");
    const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });

    const native = b.createModule(.{
        .root_source_file = b.path("ast.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "dsl", .module = dsl.module("dsl") }, .{ .name = "zxc_abi", .module = abi } },
    });

    const walk = b.createModule(.{
        .root_source_file = source,
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "ast", .module = native }, .{ .name = "zxc_abi", .module = abi } },
    });

    const executable = b.addExecutable(.{ .name = "walk", .root_module = b.createModule(.{
        .root_source_file = b.path("run.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "rx", .module = compiler.module("rx") }, .{ .name = "walk", .module = walk } },
    }) });

    b.installArtifact(executable);
}
