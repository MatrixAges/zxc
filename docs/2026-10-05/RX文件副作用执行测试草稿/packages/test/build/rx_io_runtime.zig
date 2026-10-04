const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-rx-io-runtime", "Execute generated IO calls, discarded results and sequential filesystem failures");

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

    for (cases) |case| {
        const compile = b.addRunArtifact(tool);

        compile.addArg(case.mode);

        const source = compile.addOutputFileArg("program.zig");
        const types = compile.addOutputFileArg("abi.zig");
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
                .root_source_file = b.path(b.fmt("tests/rx/runtime/io/{s}_test.zig", .{case.test_name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "fixture", .module = fixture } },
            }),
        });

        tests.root_module.addOptions("options", options);
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
