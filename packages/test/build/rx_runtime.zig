const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-rx-runtime", "Execute sequential RX programs through generated Zig");

    step.dependOn(@import("rx_store_runtime.zig").add(b, compiler, target, optimize));
    step.dependOn(@import("rx_io_runtime.zig").add(b, compiler, target, optimize));

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

    const project_tool = b.addExecutable(.{
        .name = "compile-rx-project",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/rx/runtime/compile_project.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = compiler.module("compiler") },
                .{ .name = "rx", .module = compiler.module("rx") },
                .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
            },
        }),
    });

    const store_tool = b.addExecutable(.{
        .name = "compile-rx-store",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/rx/runtime/store/compile.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = compiler.module("compiler") },
                .{ .name = "rx", .module = compiler.module("rx") },
                .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
            },
        }),
    });

    for ([_][]const u8{ "order", "borrow", "discard", "imports_forward", "imports_reverse", "conditional", "aggregate", "owned_pop", "optional_return", "optional_coalesce", "optional_list", "project_forward", "project_reverse", "diamond_forward", "diamond_reverse_calls", "diamond_reverse_modules", "diamond_reverse_both", "owned_service", "error_service", "control_last", "control_first", "control_error", "control_owned", "selection_number", "selection_text", "store_calls", "store_services" }) |mode| {
        const is_store = std.mem.startsWith(u8, mode, "store_");
        const is_control = std.mem.startsWith(u8, mode, "control_");
        const is_diamond = std.mem.startsWith(u8, mode, "diamond_");
        const compile = b.addRunArtifact(if (is_store) store_tool else if (is_control or is_diamond or std.mem.eql(u8, mode, "owned_service") or std.mem.eql(u8, mode, "error_service") or std.mem.startsWith(u8, mode, "project_")) project_tool else tool);

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

        const initial = if (is_store) b.createModule(.{
            .root_source_file = compile.addOutputFileArg("initial.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zxc_abi", .module = abi }},
        }) else null;

        const test_name = if (is_store) "store/calls" else if (std.mem.eql(u8, mode, "selection_number")) "control/number" else if (std.mem.eql(u8, mode, "selection_text")) "control/text" else if (std.mem.eql(u8, mode, "control_error")) "control/error" else if (std.mem.eql(u8, mode, "control_owned")) "control/owned" else if (is_control) "control/flow" else if (is_diamond) "diamond" else if (std.mem.startsWith(u8, mode, "project_")) "project" else if (std.mem.startsWith(u8, mode, "imports_")) "imports" else mode;

        const tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/rx/runtime/{s}_test.zig", .{test_name})),
                .target = target,
                .optimize = optimize,
                .imports = if (initial) |module| &.{
                    .{ .name = "program", .module = program },
                    .{ .name = "initial", .module = module },
                } else &.{.{ .name = "program", .module = program }},
            }),
        });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
