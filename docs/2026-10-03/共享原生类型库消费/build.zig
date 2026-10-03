const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const library = b.dependency("library", .{ .target = target, .optimize = optimize }).module("library");

    const consumer = b.addExecutable(.{ .name = "library-consumer", .root_module = b.createModule(.{
        .root_source_file = b.path("consumer.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "library", .module = library }},
    }) });

    b.default_step.dependOn(&b.addRunArtifact(consumer).step);
}
