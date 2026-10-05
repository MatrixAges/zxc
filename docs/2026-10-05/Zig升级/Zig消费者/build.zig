const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const library = b.dependency("example", .{ .target = target, .optimize = optimize }).module("library");

    const application = b.addExecutable(.{ .name = "consume", .root_module = b.createModule(.{
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "example", .module = library }},
    }) });

    b.installArtifact(application);
}
