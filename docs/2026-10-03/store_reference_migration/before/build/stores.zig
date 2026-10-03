const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, paths: []const []const u8) *std.Build.Step {
    const step = b.step("test-stores", "Verify staged Store transactions and resource failures");

    const compiler_tool = b.addExecutable(.{
        .name = "compile-store-context",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/support/store/compile.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }),
    });

    for (paths) |path| {
        const compile = b.addRunArtifact(compiler_tool);

        compile.addFileArg(b.path(b.fmt("tests/{s}.zx", .{path})));

        const program_source = compile.addOutputFileArg("program.zig");
        const emit = b.addSystemCommand(&.{"node"});

        emit.addFileArg(b.path("src/emit_store_tests.ts"));
        emit.addFileInput(b.path("src/shared/json.ts"));
        emit.addFileInput(b.path("src/shared/zig_literal.ts"));
        emit.addFileInput(b.path("src/zig_string.ts"));
        emit.addFileArg(b.path(b.fmt("tests/{s}.jsonl", .{path})));

        const test_source = emit.addOutputFileArg("cases.zig");

        const program = b.createModule(.{
            .root_source_file = program_source,
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zxc_standard", .module = compiler.module("standard") }},
        });

        const support = b.createModule(.{
            .root_source_file = b.path("tests/support/store/check.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "program", .module = program }},
        });

        const tests = b.addTest(.{
            .name = "store-transactions",
            .root_module = b.createModule(.{
                .root_source_file = test_source,
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "support", .module = support }},
            }),
        });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
