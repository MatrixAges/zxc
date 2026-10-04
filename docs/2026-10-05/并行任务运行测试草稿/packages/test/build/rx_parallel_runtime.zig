const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-rx-parallel-runtime", "Execute native RX parallel calls and Tasks with observed worker threads");

    const tool = b.addExecutable(.{
        .name = "compile-rx-parallel",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/rx/runtime/parallel_compile.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = compiler.module("compiler") },
                .{ .name = "rx", .module = compiler.module("rx") },
                .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
            },
        }),
    });

    const cases = [_]struct { mode: []const u8, test_name: []const u8 }{
        .{ .mode = "direct", .test_name = "results" },
        .{ .mode = "service", .test_name = "results" },
        .{ .mode = "error_first", .test_name = "error" },
        .{ .mode = "allocation_first", .test_name = "error" },
        .{ .mode = "input_error", .test_name = "input" },
        .{ .mode = "task_direct", .test_name = "results" },
        .{ .mode = "task_service", .test_name = "results" },
        .{ .mode = "task_nested", .test_name = "results" },
        .{ .mode = "task_error_first", .test_name = "task_error" },
        .{ .mode = "task_allocation_first", .test_name = "task_error" },
        .{ .mode = "task_input_error", .test_name = "task_input" },
        .{ .mode = "task_capture", .test_name = "task_capture" },
        .{ .mode = "task_borrowed", .test_name = "task_borrowed" },
        .{ .mode = "task_borrowed_nested", .test_name = "task_borrowed" },
        .{ .mode = "thread_direct", .test_name = "thread" },
        .{ .mode = "thread_service", .test_name = "thread" },
        .{ .mode = "thread_task", .test_name = "thread" },
        .{ .mode = "thread_nested", .test_name = "thread" },
    };

    for (cases) |case| {
        const mode = case.mode;
        const compile = b.addRunArtifact(tool);

        compile.addArg(mode);

        const source = compile.addOutputFileArg("program.zig");
        const types = compile.addOutputFileArg("abi.zig");
        const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });

        const program = b.createModule(.{
            .root_source_file = source,
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zxc_abi", .module = abi }},
        });

        const options = b.addOptions();

        options.addOption(bool, "allocation_first", std.mem.endsWith(u8, mode, "allocation_first"));
        options.addOption(bool, "nested", std.mem.eql(u8, mode, "thread_nested"));

        const tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/rx/runtime/parallel/{s}_test.zig", .{case.test_name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "program", .module = program }},
            }),
        });

        tests.root_module.addOptions("options", options);
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
