const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-rx-runtime", "Execute sequential RX programs through generated Zig");
    const tool = b.addExecutable(.{
        .name = "compile-rx-module",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/rx/runtime/compile.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = compiler.module("compiler") },
                .{ .name = "rx", .module = compiler.module("rx") },
                .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
            },
        }),
    });

    for ([_][]const u8{ "order", "borrow", "discard", "imports_forward", "imports_reverse", "conditional", "aggregate" }) |mode| {
        const compile = b.addRunArtifact(tool);

        compile.addArg(mode);

        const generated = compile.addOutputFileArg("program.zig");
        const types = compile.addOutputFileArg("abi.zig");
        const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
        const program = b.createModule(.{
            .root_source_file = generated,
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zxc_abi", .module = abi }},
        });
        const test_name = if (std.mem.startsWith(u8, mode, "imports_")) "imports" else mode;
        const tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/rx/runtime/{s}_test.zig", .{test_name})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "program", .module = program }},
            }),
        });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
