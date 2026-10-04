const std = @import("std");

pub fn build(b: *std.Build) void {
    const dependency = b.dependency("compiler", .{});

    const app = b.addExecutable(.{ .name = "inspect-project", .root_module = b.createModule(.{
        .root_source_file = b.path("inspect.zig"),
        .target = b.graph.host,
        .imports = &.{.{ .name = "compiler", .module = dependency.module("compiler") }},
    }) });

    b.installArtifact(app);
}
