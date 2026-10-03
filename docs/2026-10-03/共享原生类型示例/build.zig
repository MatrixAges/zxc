const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = b.graph.host, .optimize = optimize }).module("compiler");

    const generator = b.addExecutable(.{ .name = "generate", .root_module = b.createModule(.{
        .root_source_file = b.path("generate.zig"),
        .target = b.graph.host,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler }},
    }) });

    const generate = b.addRunArtifact(generator);
    const source = generate.addOutputFileArg("program.zig");
    const types = generate.addOutputFileArg("abi.zig");
    const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });

    const native = b.createModule(.{
        .root_source_file = b.path("native.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "zxc_abi", .module = abi }},
    });

    const program = b.createModule(.{
        .root_source_file = source,
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "transport", .module = native } },
    });

    const consumer = b.addExecutable(.{ .name = "shared-abi", .root_module = b.createModule(.{
        .root_source_file = b.path("consumer.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "zxc_abi", .module = abi } },
    }) });

    b.default_step.dependOn(&b.addRunArtifact(consumer).step);
}
