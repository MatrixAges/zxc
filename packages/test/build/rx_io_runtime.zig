const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-rx-io-runtime", "Execute generated IO calls, discarded results and sequential filesystem failures");
    const library_step = b.step("test-rx-io-library", "Execute IO and pure entries after library replay, import and republication");
    const all = b.step("test-rx-io", "Execute source and library IO workflows");

    all.dependOn(step);
    all.dependOn(library_step);

    const replay_tool = b.addExecutable(.{
        .name = "replay-rx-io-library",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/rx/runtime/parallel/library/replay.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }),
    });

    const consumer_tool = b.addExecutable(.{
        .name = "consume-rx-io-library",
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

    const tool = b.addExecutable(.{
        .name = "compile-rx-io",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/rx/runtime/io_compile.zig"),
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
        .{ .mode = "workflow", .test_name = "workflow" },
        .{ .mode = "service", .test_name = "workflow" },
        .{ .mode = "task", .test_name = "workflow" },
        .{ .mode = "selection", .test_name = "selection" },
        .{ .mode = "discard", .test_name = "discard" },
        .{ .mode = "void", .test_name = "void" },
        .{ .mode = "void_service", .test_name = "void" },
        .{ .mode = "input_error", .test_name = "input" },
    };

    const Route = enum { source, archive, rx, zx, republish };

    for (cases) |case| for (std.meta.tags(Route)) |route| for ([_]bool{ false, true }) |reverse| for ([_]bool{ false, true }) |pure| {
        if (route == .source and (reverse or pure)) continue;

        const compile = b.addRunArtifact(tool);

        compile.addArg(case.mode);

        const emit = if (route == .source) compile else block: {
            var artifact = compile.addOutputFileArg("workflow.zxlib");
            var export_name: []const u8 = if (pure) "scalar" else if (reverse) "alias" else "workflow";

            compile.addArg(if (reverse) "archive_reverse" else "archive_forward");

            if (route != .archive) {
                const consume = b.addRunArtifact(consumer_tool);

                consume.addFileArg(artifact);
                consume.addArg(export_name);
                consume.addArg(if (route == .zx) "zx" else "rx");

                artifact = consume.addOutputFileArg("consumer.zxlib");
                export_name = "consumer";
            }

            if (route == .republish) {
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

        const standard = b.createModule(.{
            .root_source_file = compiler.path("standard/src/root.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zxc_abi", .module = abi }},
        });

        const fixture = b.createModule(.{
            .root_source_file = b.path("tests/standard/resources/fs/fixture.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "standard", .module = standard }},
        });

        const program = b.createModule(.{
            .root_source_file = source,
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "zxc_standard", .module = standard } },
        });

        const options = b.addOptions();

        options.addOption(bool, "service", std.mem.eql(u8, case.mode, "void_service"));

        const tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/rx/runtime/io/{s}_test.zig", .{if (pure) "pure" else case.test_name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "fixture", .module = fixture } },
            }),
        });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        tests.root_module.addOptions("options", options);

        const owner = if (route == .source) step else library_step;

        owner.dependOn(&b.addRunArtifact(tests).step);
    };

    return all;
}
