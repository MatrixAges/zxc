const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode, logical_paths: []const []const u8) *std.Build.Step {
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

    const paths = b.allocator.alloc([]const u8, logical_paths.len + 1) catch @panic("out of memory");
    paths[0] = "runtime/evaluation_order/program";
    @memcpy(paths[1..], logical_paths);

    for (paths, 0..) |path, index| {
        const logical = index != 0;
        const compile = b.addRunArtifact(tool);

        compile.addFileArg(b.path(b.fmt("tests/{s}.zx", .{path})));

        const generated = compile.addOutputFileArg("program.zig");
        const types = compile.addOutputFileArg("abi.zig");
        const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
        const probe = b.createModule(.{ .root_source_file = b.path("tests/runtime/evaluation_order/probe.zig"), .target = target, .optimize = optimize });

        const program = b.createModule(.{
            .root_source_file = generated,
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "probe", .module = probe },
                .{ .name = "zxc_abi", .module = abi },
            },
        });

        var test_source = b.path("tests/runtime/evaluation_order/trace_test.zig");
        const trace_check = b.createModule(.{
            .root_source_file = b.path("tests/runtime/evaluation_order/logical_check.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "probe", .module = probe } },
        });

        if (logical) {
            const emit = b.addSystemCommand(&.{"node"});

            emit.addFileArg(b.path("src/emit_logical_trace_tests.ts"));
            emit.addFileInput(b.path("src/shared/json.ts"));
            emit.addFileInput(b.path("src/shared/zig_literal.ts"));
            emit.addFileInput(b.path("src/zig_string.ts"));
            emit.addFileArg(b.path(b.fmt("tests/{s}.jsonl", .{path})));
            test_source = emit.addOutputFileArg("logical_test.zig");
        }

        const tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = test_source,
                .target = target,
                .optimize = optimize,
                .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "probe", .module = probe } },
            }),
        });

        if (logical) tests.root_module.addImport("trace_check", trace_check);

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
