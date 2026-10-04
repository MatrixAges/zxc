const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-expression-runtime", "Execute standalone bound expression programs");
    const tool = b.addExecutable(.{
        .name = "compile-bound-expression",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/expressions/runtime/compile.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }),
    });

    for ([_][]const u8{ "order", "branch", "borrow" }) |mode| {
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
        const tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/expressions/runtime/{s}_test.zig", .{mode})),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "program", .module = program }},
            }),
        });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
