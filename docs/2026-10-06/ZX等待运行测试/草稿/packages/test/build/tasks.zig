const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const all = b.step("test-zx-tasks", "Validate ZX task analysis and execution");
    const step = b.step("test-zx-tasks-analysis", "Validate ZX task ownership captures finite errors and parallel results");

    for ([_][]const u8{ "shape", "acceptance", "rejection", "allocation" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/language/expressions/tasks/analysis/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    all.dependOn(step);
    all.dependOn(@import("tasks_await_runtime.zig").add(b, compiler, target, optimize));

    return all;
}
