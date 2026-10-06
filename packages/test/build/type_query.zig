const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-type-query", "Validate generated type query propagation prefixes and allocation ownership");
    const frontend = compiler.module("frontend");

    for ([_][]const u8{ "propagation", "prefix", "growth", "resources" }) |name| {
        const tests = b.addTest(.{ .name = b.fmt("type-query-{s}", .{name}), .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/ir/types/query/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "frontend", .module = frontend },
                .{ .name = "query", .module = frontend.import_table.get("generated_type_query").? },
                .{ .name = "zx", .module = frontend.import_table.get("zx").? },
            },
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
