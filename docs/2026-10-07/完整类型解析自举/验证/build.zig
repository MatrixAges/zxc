const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const compiler = b.dependency("compiler", .{ .target = target, .optimize = optimize });

    const tests = b.addTest(.{
        .filters = &.{ "types:", "positive analyze:" },
        .root_module = b.createModule(.{
            .root_source_file = compiler.path("tests/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = compiler.module("frontend") },
                .{ .name = "zx", .module = compiler.module("frontend").import_table.get("zx").? },
            },
        }),
    });

    b.default_step.dependOn(&b.addRunArtifact(tests).step);
}
