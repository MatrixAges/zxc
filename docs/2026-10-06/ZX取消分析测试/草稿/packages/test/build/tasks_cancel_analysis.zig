const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-zx-cancel-analysis", "Validate explicit ZX cancellation ownership and finite effects");

    const fixture = b.createModule(.{
        .root_source_file = b.path("tests/language/expressions/tasks/analysis/fixture.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    });

    for ([_][]const u8{ "shape", "acceptance", "rejection", "allocation" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/language/expressions/tasks/cancel_analysis/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "compiler", .module = compiler.module("compiler") }, .{ .name = "zx", .module = compiler.module("compiler").import_table.get("zx").? }, .{ .name = "task_fixture", .module = fixture } },
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
