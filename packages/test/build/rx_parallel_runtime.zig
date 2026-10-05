const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-rx-parallel-runtime", "Execute native RX parallel calls and Tasks with observed worker threads");
    const migration = b.step("test-rx-value-migration-parallel", "Execute the migrated Task capture case across source and eight library routes");
    const owned = b.step("test-rx-owned-runtime", "Execute owned inputs across RX parallel source and compiled library boundaries");
    const archived = b.step("test-rx-parallel-library", "Execute parallel workflows replayed from unified library artifacts");
    const imported = b.step("test-rx-parallel-import", "Execute parallel workflows imported and republished by RX and ZX consumers");
    const all = b.step("test-rx-parallel", "Execute source, archived and imported RX parallel workflows");

    all.dependOn(step);
    all.dependOn(archived);
    all.dependOn(imported);

    const consumer_tool = b.addExecutable(.{
        .name = "consume-rx-parallel",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/rx/runtime/parallel/library/consume.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = compiler.module("compiler") },
                .{ .name = "rx", .module = compiler.module("rx") },
                .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
            },
        }),
    });

    const replay_tool = b.addExecutable(.{
        .name = "replay-rx-parallel",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/rx/runtime/parallel/library/replay.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }),
    });

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

    tool.root_module.addAnonymousImport("rx_collection_fixtures", .{ .root_source_file = b.path("tests/rx/support/collections/root.zig"), .target = target, .optimize = optimize });

    const cases = [_]struct { mode: []const u8, test_name: []const u8 }{
        .{ .mode = "owned_module", .test_name = "owned" },
        .{ .mode = "owned_direct", .test_name = "owned" },
        .{ .mode = "owned_task", .test_name = "owned" },
        .{ .mode = "owned_service", .test_name = "owned" },
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

    for (cases) |case| for ([_][]const u8{ "source", "forward", "reverse", "rx_forward", "rx_reverse", "zx_forward", "zx_reverse", "republish_forward", "republish_reverse" }) |route| {
        const mode = case.mode;
        const compile = b.addRunArtifact(tool);

        compile.addArg(mode);

        const emit = if (std.mem.eql(u8, route, "source")) compile else block: {
            var artifact = compile.addOutputFileArg("workflow.zxlib");
            const reverse = std.mem.endsWith(u8, route, "reverse");
            var export_name: []const u8 = if (reverse) "alias" else "workflow";

            compile.addArg(if (reverse) "archive_reverse" else "archive_forward");

            if (std.mem.indexOfScalar(u8, route, '_') != null) {
                const consume = b.addRunArtifact(consumer_tool);

                consume.addFileArg(artifact);
                consume.addArg(export_name);
                consume.addArg(if (std.mem.startsWith(u8, route, "zx_")) "zx" else "rx");

                artifact = consume.addOutputFileArg("consumer.zxlib");
                export_name = "consumer";
            }

            if (std.mem.startsWith(u8, route, "republish_")) {
                const consume = b.addRunArtifact(consumer_tool);

                consume.addFileArg(artifact);
                consume.addArg(export_name);
                consume.addArg("zx");

                artifact = consume.addOutputFileArg("republished.zxlib");
            }

            const replay = b.addRunArtifact(replay_tool);

            replay.addFileArg(artifact);
            replay.addArg(export_name);

            break :block replay;
        };

        const source = emit.addOutputFileArg("program.zig");
        const types = emit.addOutputFileArg("abi.zig");
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

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        tests.root_module.addOptions("options", options);

        const owner = if (std.mem.eql(u8, route, "source")) step else if (std.mem.indexOfScalar(u8, route, '_') == null) archived else imported;
        const run = b.addRunArtifact(tests);

        owner.dependOn(&run.step);

        if (std.mem.eql(u8, mode, "task_capture")) migration.dependOn(&run.step);
        if (std.mem.startsWith(u8, mode, "owned_")) owned.dependOn(&run.step);
    };

    return all;
}
