const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-typed-try-native-contract", "Validate finite native errors and explicit concurrency contracts");

    for ([_][]const u8{ "declaration", "rejection" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/language/expressions/typed_try/native_contract/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        step.dependOn(&b.addRunArtifact(tests).step);
    }

    const analysis = b.step("test-typed-try-analysis", "Validate typed capture shapes and success refinement");

    for ([_][]const u8{ "shape", "refinement", "rejection", "allocation" }) |name| {
        const tests = b.addTest(.{ .root_module = b.createModule(.{
            .root_source_file = b.path(b.fmt("tests/language/expressions/typed_try/analysis/{s}_test.zig", .{name})),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
        }) });

        tests.root_module.addAnonymousImport("allocation_testing", .{ .root_source_file = b.path("tests/support/allocation_testing.zig"), .target = target, .optimize = optimize });
        analysis.dependOn(&b.addRunArtifact(tests).step);
    }

    const all = b.step("test-typed-try", "Validate typed errors and captures");

    all.dependOn(step);
    all.dependOn(analysis);

    return all;
}
