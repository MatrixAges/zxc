const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-rx-parallel-runtime", "Execute native RX parallel calls and observe worker threads");

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

    for ([_][]const u8{ "direct", "service", "error_first", "allocation_first", "input_error" }) |mode| {
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

        options.addOption(bool, "allocation_first", std.mem.eql(u8, mode, "allocation_first"));

        const tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/rx/runtime/parallel/{s}_test.zig", .{if (std.mem.eql(u8, mode, "input_error")) "input" else if (std.mem.endsWith(u8, mode, "first")) "error" else "results"})),
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
