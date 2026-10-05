const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const dependency = b.dependency("library", .{ .target = target });

    const app = b.addExecutable(.{ .name = "stdio-consumer", .root_module = b.createModule(.{
        .root_source_file = b.path("main.zig"),
        .target = target,
        .imports = &.{.{ .name = "library", .module = dependency.module("library") }},
    }) });

    b.installArtifact(app);
}
