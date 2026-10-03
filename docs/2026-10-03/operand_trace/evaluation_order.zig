const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-evaluation-order", "Observe generated operand calls and early failure");

    const tool = b.addExecutable(.{
        .name = "compile-evaluation-order",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/runtime/evaluation_order/compile.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }),
    });

    const compile = b.addRunArtifact(tool);

    compile.addFileArg(b.path("tests/runtime/evaluation_order/program.zx"));

    const generated = compile.addOutputFileArg("program.zig");
    const probe = b.createModule(.{ .root_source_file = b.path("tests/runtime/evaluation_order/probe.zig"), .target = target, .optimize = optimize });

    const program = b.createModule(.{
        .root_source_file = generated,
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "probe", .module = probe },
            .{ .name = "zx_runtime", .module = compiler.module("runtime") },
        },
    });

    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/runtime/evaluation_order/trace_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "probe", .module = probe } },
        }),
    });

    step.dependOn(&b.addRunArtifact(tests).step);

    return step;
}
