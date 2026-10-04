const std = @import("std");

pub fn build(b: *std.Build) void {
    const library = b.dependency("native", .{});

    const app = b.addExecutable(.{
        .name = "consume",
        .root_module = b.createModule(.{
            .root_source_file = b.path("consume.zig"),
            .target = b.graph.host,
            .imports = &.{.{ .name = "once", .module = library.module("./once") }},
        }),
    });

    b.installArtifact(app);
}
