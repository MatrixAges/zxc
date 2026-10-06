const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-zx-task-lifecycle", "Validate real ZX task cancellation joining and caller result preservation");

    const tool = b.addExecutable(.{ .name = "compile-zx-task-lifecycle", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/language/expressions/tasks/runtime/lifecycle/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "cancel", "scope_exit", "early_return", "caller_error", "block_exit", "completed", "direct", "cleanup" }) |name| {
        const compile = b.addRunArtifact(tool);

        compile.addFileArg(b.path(b.fmt("tests/language/expressions/tasks/runtime/lifecycle/{s}/main.zx", .{name})));

        const source = compile.addOutputFileArg("program.zig");
        const types = compile.addOutputFileArg("abi.zig");
        const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
        const host = b.createModule(.{ .root_source_file = b.path("tests/language/expressions/tasks/runtime/lifecycle/native/host.zig"), .target = target, .optimize = optimize });

        const program = b.createModule(.{
            .root_source_file = source,
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "host", .module = host } },
        });

        const check = b.createModule(.{
            .root_source_file = b.path("tests/language/expressions/tasks/runtime/lifecycle/check.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "host", .module = host } },
        });

        const tests = b.addTest(.{ .name = b.fmt("zx-lifecycle-{s}", .{name}), .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/language/expressions/tasks/runtime/lifecycle/{s}/execution_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "host", .module = host }, .{ .name = "lifecycle_check", .module = check } },
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
