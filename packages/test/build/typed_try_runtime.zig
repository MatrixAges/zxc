const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-typed-try-runtime", "Execute typed captures with statically linked native modules");

    const tool = b.addExecutable(.{ .name = "compile-typed-try-runtime", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/language/expressions/typed_try/runtime/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "scalar", "optional", "void", "infallible", "empty", "before", "after", "nested", "index", "compound" }) |name| {
        const compile = b.addRunArtifact(tool);

        compile.addFileArg(b.path(b.fmt("tests/language/expressions/typed_try/runtime/{s}/main.zx", .{name})));

        const source = compile.addOutputFileArg("program.zig");
        const types = compile.addOutputFileArg("abi.zig");
        const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
        const host = b.createModule(.{ .root_source_file = b.path("tests/language/expressions/typed_try/runtime/native/host.zig"), .target = target, .optimize = optimize });

        const program = b.createModule(.{
            .root_source_file = source,
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "host", .module = host } },
        });

        const check = b.createModule(.{
            .root_source_file = b.path("tests/language/expressions/typed_try/runtime/check.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "host", .module = host } },
        });

        const tests = b.addTest(.{ .name = b.fmt("typed-try-{s}", .{name}), .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/language/expressions/typed_try/runtime/{s}/execution_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "host", .module = host }, .{ .name = "capture_check", .module = check } },
        }) });

        step.dependOn(&b.addRunArtifact(tests).step);
    }

    return step;
}
