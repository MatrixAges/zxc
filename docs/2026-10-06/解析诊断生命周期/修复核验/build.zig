const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = b.graph.host, .optimize = optimize });

    const driver = b.addExecutable(.{ .name = "diagnostic-lifetime", .root_module = b.createModule(.{
        .root_source_file = b.path("../diagnostic_driver.zig"),
        .target = b.graph.host,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    b.default_step.dependOn(&b.addRunArtifact(driver).step);
}
