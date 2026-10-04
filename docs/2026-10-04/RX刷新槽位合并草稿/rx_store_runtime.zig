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

    for ([_][]const u8{ "isolation", "union" }) |mode| {
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
                .root_source_file = b.path(b.fmt("tests/rx/runtime/store/dual/{s}_test.zig", .{mode})),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "program", .module = modules[0] },
                    .{ .name = "left", .module = modules[1] },
                    .{ .name = "right", .module = modules[2] },
                },
            }),
        });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
