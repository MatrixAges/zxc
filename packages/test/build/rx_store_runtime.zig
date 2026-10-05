const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const tool = b.addExecutable(.{
        .name = "compile-rx-dual-store",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/rx/runtime/store/dual/compile.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "compiler", .module = compiler.module("compiler") },
                .{ .name = "rx", .module = compiler.module("rx") },
                .{ .name = "rx_analysis", .module = compiler.module("rx_analysis") },
            },
        }),
    });

    const step = b.step("test-rx-store-runtime", "Execute physical Store isolation and refresh boundaries");

    for ([_][]const u8{ "isolation", "union", "nested", "nested_deep" }) |mode| {
        const compile = b.addRunArtifact(tool);

        compile.addArg(mode);

        const generated = compile.addOutputFileArg("program.zig");
        const types = compile.addOutputFileArg("abi.zig");
        const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
        var modules: [3]*std.Build.Module = undefined;

        for (&modules, 0..) |*module, index| {
            module.* = b.createModule(.{
                .root_source_file = if (index == 0) generated else compile.addOutputFileArg(if (index == 1) "left.zig" else "right.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{.{ .name = "zxc_abi", .module = abi }},
            });
        }

        const tests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(b.fmt("tests/rx/runtime/store/dual/{s}_test.zig", .{if (std.mem.startsWith(u8, mode, "nested")) "nested" else mode})),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "program", .module = modules[0] },
                    .{ .name = "left", .module = modules[1] },
                    .{ .name = "right", .module = modules[2] },
                },
            }),
        });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    const memory_step = b.step("test-rx-memory-state", "Execute compiler generated application memory State across calls");

    const memory_cases = [_]struct { name: []const u8, mode: []const u8 }{
        .{ .name = "state", .mode = "memory" },
        .{ .name = "readonly", .mode = "memory_readonly" },
        .{ .name = "failure", .mode = "memory_failure" },
        .{ .name = "request", .mode = "memory" },
        .{ .name = "request_failure", .mode = "memory_failure" },
        .{ .name = "request_registration", .mode = "memory" },
        .{ .name = "request_readonly", .mode = "memory_pure_readonly" },
    };

    for (memory_cases) |case| {
        const generate = b.addRunArtifact(tool);

        generate.addArg(case.mode);

        const directory = generate.addOutputDirectoryArg("generated");
        const run = b.addSystemCommand(&.{"node"});

        run.addFileArg(b.path("tests/rx/runtime/store/memory/run_test.ts"));
        run.addFileInput(b.path("tests/support/allocation_testing.zig"));
        run.addArg(b.graph.zig_exe);
        run.setEnvironmentVariable("ZXC_TEST_OPTIMIZE", @tagName(optimize));
        run.addDirectoryArg(directory);
        run.addFileArg(b.path(b.fmt("tests/rx/runtime/store/memory/{s}_test.zig", .{case.name})));
        memory_step.dependOn(&run.step);
    }

    step.dependOn(memory_step);
    step.dependOn(@import("rx_store_io.zig").add(b, compiler, target, optimize));

    return step;
}
