const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-typed-try-native-abi", "Validate finite errors against statically linked native implementations");
    const directory = "tests/language/expressions/typed_try/native_abi";

    const tool = b.addExecutable(.{ .name = "compile-typed-try-native-abi", .root_module = b.createModule(.{
        .root_source_file = b.path(directory ++ "/compile.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    for ([_][]const u8{ "scalar", "optional", "void", "empty", "opaque", "exact", "subset", "infallible" }) |name| {
        const generate = b.addRunArtifact(tool);

        generate.addFileArg(b.path(directory ++ "/main.zx"));
        generate.addFileArg(b.path(b.fmt("{s}/{s}/host.d.zx", .{ directory, name })));

        const source = generate.addOutputFileArg("program.zig");
        const types = generate.addOutputFileArg("abi.zig");
        const abi = b.createModule(.{ .root_source_file = types, .target = target, .optimize = optimize });
        const host = b.createModule(.{ .root_source_file = b.path(b.fmt("{s}/{s}/host.zig", .{ directory, name })), .target = target, .optimize = optimize });

        const program = b.createModule(.{
            .root_source_file = source,
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "zxc_abi", .module = abi }, .{ .name = "host", .module = host } },
        });

        const tests = b.addTest(.{ .name = b.fmt("typed-try-abi-{s}", .{name}), .root_module = b.createModule(.{
            .root_source_file = b.path(directory ++ "/execution_test.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{ .{ .name = "program", .module = program }, .{ .name = "host", .module = host } },
        }) });

        if (std.mem.eql(u8, name, "exact") or std.mem.eql(u8, name, "subset") or std.mem.eql(u8, name, "infallible")) {
            step.dependOn(&b.addRunArtifact(tests).step);
        } else {
            tests.expect_errors = .{ .contains = if (std.mem.eql(u8, name, "opaque")) "global error set cannot cast into a smaller set" else "'error.ZetaFailure' not a member of destination error set" };

            step.dependOn(&tests.step);
        }
    }

    return step;
}
