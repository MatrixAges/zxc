const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const dependency = b.dependency("bundle", .{ .target = target, .optimize = optimize });

    const module = b.createModule(.{
        .root_source_file = b.path("consumer_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "library", .module = dependency.module(@import("public_name.zig").value) }},
    });

    b.default_step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = module })).step);
}
