const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const dependency = b.dependency("bundle", .{ .target = target, .optimize = optimize });
    const module = b.createModule(.{
        .root_source_file = b.path("consumer_test.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "identity", .module = dependency.module(".") },
            .{ .name = "alias", .module = dependency.module("./alias") },
            .{ .name = "workflow", .module = dependency.module("./workflow") },
            .{ .name = "toggle", .module = dependency.module("./toggle") },
            .{ .name = "types", .module = dependency.module("./types") },
        },
    });

    b.default_step.dependOn(&b.addRunArtifact(b.addTest(.{ .root_module = module })).step);
}
