const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-type-resolution", "Validate generated type resolution depth state and source views");
    const frontend = compiler.module("frontend");

    for ([_][]const u8{ "initialization", "names", "nodes", "ordering", "views", "resources" }) |name| {
        const tests = b.addTest(.{ .name = b.fmt("type-resolution-{s}", .{name}), .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/language/types/resolution/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "frontend", .module = frontend },
                .{ .name = "compiler", .module = compiler.module("compiler") },
                .{ .name = "zx", .module = frontend.import_table.get("zx").? },
            },
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
