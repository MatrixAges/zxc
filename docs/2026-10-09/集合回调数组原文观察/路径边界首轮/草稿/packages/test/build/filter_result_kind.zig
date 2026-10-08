const std = @import("std");

pub fn add(b: *std.Build, compiler: *std.Build.Dependency, target: std.Build.ResolvedTarget, optimize: std.builtin.OptimizeMode) *std.Build.Step {
    const step = b.step("test-filter-result-kind", "Validate actual generated filter list results and upstream container observations");

    const tool = b.addExecutable(.{ .name = "compile-filter-result-kind", .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/filter_result_kind/compile.zig"),
        .target = target, .optimize = optimize,
        .imports = &.{.{ .name = "compiler", .module = compiler.module("compiler") }},
    }) });

    const generate = b.addRunArtifact(tool);
    const source = generate.addOutputFileArg("filter.zig");
    const program = b.createModule(.{ .root_source_file = source, .target = target, .optimize = optimize });

    const tests = b.addTest(.{ .root_module = b.createModule(.{
        .root_source_file = b.path("tests/collections/filter_result_kind/result_test.zig"),
        .target = target, .optimize = optimize,
        .imports = &.{.{ .name = "program", .module = program }},
    }) });

    step.dependOn(&b.addRunArtifact(tests).step);

    return step;
}
