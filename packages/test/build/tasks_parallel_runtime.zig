const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-zx-parallel-runtime", "Validate ZX parallel overlap source ordered errors joining and startup cleanup");

    const tool = b.addExecutable(.{ .name = "compile-zx-parallel-runtime", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/language/expressions/tasks/runtime/parallel/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "values", "source_order", "all_join", "mixed", "all_void", "capture", "initial_failure", "mid_failure" }) |name| {
        const compile = b.addRunArtifact(tool);

        compile.addFileArg(b.path(b.fmt("tests/language/expressions/tasks/runtime/parallel/{s}/main.zx", .{name})));

        const source = compile.addOutputFileArg("program.zig");
        const types = compile.addOutputFileArg("abi.zig");
        const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
        const host = b.createModule(.{ .root_source_file = b.path("tests/language/expressions/tasks/runtime/parallel/native/host.zig"), .target = target, .optimize = optimize });

        const program = b.createModule(.{
            .root_source_file = source,
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "host", .module = host } },
        });

        const check = b.createModule(.{
            .root_source_file = b.path("tests/language/expressions/tasks/runtime/parallel/check.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "host", .module = host } },
        });

        const tests = b.addTest(.{ .name = b.fmt("zx-parallel-{s}", .{name}), .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/language/expressions/tasks/runtime/parallel/{s}/execution_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "host", .module = host }, .{ .name = "parallel_check", .module = check } },
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
