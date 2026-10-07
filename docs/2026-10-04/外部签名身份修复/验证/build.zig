const std = @import("std");

pub fn build(b: *std.Build) void {
    const compiler = b.dependency("compiler", .{});
    const step = b.step("test", "Run existing nominal identity regression cases");

    for ([_][]const u8{ "origins", "resources" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/incremental/nominal/{s}_test.zig", .{name})),
            .target = b.graph.host,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }
}
