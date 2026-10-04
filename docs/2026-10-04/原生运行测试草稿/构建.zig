const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-native-runtime", "Execute original and relinked native ABI bundles");
    const tool = b.addExecutable(.{
        .name = "compile-native-runtime",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/incremental/native_runtime/compile.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }),
    });
    const compile = b.addRunArtifact(tool);

    for ([_][]const u8{ "original", "linked" }) |name| {
        const source = compile.addOutputFileArg(b.fmt("{s}.zig", .{name}));
        const types = compile.addOutputFileArg(b.fmt("{s}_abi.zig", .{name}));
        const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
        const host = b.createModule(.{
            .root_source_file = b.path("tests/incremental/native_runtime/choice.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "zxc_abi", .module = abi }},
        });
        const program = b.createModule(.{
            .root_source_file = source,
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "choice", .module = host } },
        });

        const tests = b.addTest(.{
            .name = b.fmt("native-{s}", .{name}),
            .root_module = b.createModule(.{
                .root_source_file = b.path("tests/incremental/native_runtime/runtime_test.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "host", .module = host } },
            }),
        });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
